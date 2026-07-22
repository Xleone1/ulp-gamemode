# Sistema de Teles y Garages — Clean Architecture

## Proposito

Sistema de teleports (teles) y garages asociados: creacion, edicion (nombre, ubicacion, garage, propietario), borrado, y teletransporte de jugadores. Cada tele es un par de pickups vinculados (ida-vuelta). Los garages extendidos (GarageEx) permiten guardar vehiculos dentro de un tele.

## Estructura de archivos

| Archivo | Contenido | Patron |
|---------|-----------|--------|
| `teles_main.pwn` | Logica core: CrearTele, BorrarTele, SaveTele, LoadTeles, CrearGarage, LoadGarageEx, SaveGarageEx. Toda funcion que ejecuta accion sobre el estado del sistema. Ademas contiene las funciones de dialogo (Show*) y las 3 funciones nuevas del refactor (SetTeleTipo, IrTele, AsignarTelePropietario). | x_main |
| `teles_data.pwn` | Persistencia: FetchTeleDB, FetchGarageExDB, SaveTeleDB, SaveGarageExDB. Cada funcion encapsula `mysql_format` + `mysql_query`. Nunca se llama mysql_query directamente desde main. | x_data |
| `teles_utils.pwn` | Helpers puros sin side effects: IsPlayerNearGarageEx, IsPlayerInGarageEx, IsVehicleInGarageEx, PlayerHaveTeleKeys, GetNextTeleID, GetNextGarageID, IsValidGarageEdit, IsValidGarageEx. Solo leen estado, nunca modifican nada. | x_utils |
| `teles_commands.pwn` | Comandos del jugador (OnPlayerCommandTeles, OnPlayerCommandTelesLlaves, OnPlayerCommandTelesMapper) y respuestas de dialog (OnTelesDialogResponse). Cada comando es un branch else-if dentro del dispatcher. | x_commands |

**Orden de include** (respeta resolucion top-to-bottom de Pawn):
```
teles_data.pwn → teles_utils.pwn → teles_main.pwn → teles_commands.pwn
```

## Comandos

| Comando | Sintaxis | Permisos | Descripcion |
|---------|----------|----------|-------------|
| `/Crear Tele` | `/Crear Tele` (x2: pos1 + pos2) | Mapper ≥ 1 | Crea un par de teles en dos pasos: primero la posicion "Uno", luego la "Dos" |
| `/Crear Garage` | `/Crear Garage [ID_Tele]` (x2) | Mapper ≥ 1 | Crea un garage extendido para el tele, en dos pasos: pos1 cerca del origen, pos2 cerca del destino |
| `/Llaves PuertaEx` | `/Llaves PuertaEx` | Tener llaves del tele | Abre/cierra la puerta del tele donde el jugador esta parado |
| `/Llaves GarageEx` | `/Llaves GarageEx` | Tener llaves del tele | Abre/cierra la puerta del garage donde el jugador esta parado |
| `/Tele Tipo Banco` | `/Tele Tipo Banco` | Mapper ≥ 1 + pickup | Marca el tele como entrada de banco |
| `/Tele Tipo Hotel` | `/Tele Tipo Hotel` | Mapper ≥ 1 + pickup | Marca el tele como entrada de hotel |
| `/IrTele` | `/IrTele [ID_Tele]` | Mapper ≥ 1 | Teletransporta al jugador a la posicion del tele indicado |
| `/TelePos` | `/TelePos [ID_Tele]` | Mapper ≥ 1 | Mueve el tele indicado a la posicion actual del jugador |
| `/Borrar Tele` | `/Borrar Tele` | Mapper ≥ 1 + pickup | Elimina el par de teles y su garage si tiene |
| `/TeleP` | `/TeleP [Tipo] [ID]` | Mapper ≥ 1 + pickup | Asigna propietario. Tipo: 0=Faccion, 1=Negocio, 2=Casa |
| `/Editar Tele` | `/Editar Tele [ID]` o `/Editar Tele` (pickup) | Admin ≥ 9 | Abre Dialog 175 para editar nombre, ubicacion, llaves o eliminar el tele. No extraido — queda inline en main.pwn (ver nota abajo). |

**Nota sobre `/Editar Tele`:** Este comando **no se extrajo** al dispatcher porque vive dentro del contenedor `strfind(cmdtext, "/Editar", ...)` compartido con otros comandos (`/Editar Pistas`, `/Editar Impuestos`). Extraerlo requeriria refactorizar todo el bloque `/Editar`, fuera del alcance de este pass. Funciona correctamente llamando a `ShowDialogEditTele(playerid, teleid)` (definida en teles_main.pwn), que esta disponible gracias al include temprano de s_main.pwn (main.pwn:57).

## Dialogs

| Dialog ID | Nombre | Que muestra | Disparador |
|-----------|--------|-------------|------------|
| **175** | Menu principal editar tele | TABLIST: "Nombre [ID]" (editar), "Nombre [ID_go]" (editar), "Ubicaciones" (ver/editar), "Llaves" (ver/editar), "Eliminar" | `/Editar Tele [ID]` o `/Editar Tele` parado en pickup |
| **176** | Editar nombre | Input con nombre actual del tele | Opcion 0 o 1 del Dialog 175 |
| **177** | Ver/editar ubicaciones | TABLIST_HEADERS con PosX/Y/Z/RZ/Mundo/Interior de ambos teles, mas "Mi Ubicacion" y acceso al garage | Opcion 2 del Dialog 175 |
| **178** | Ver/editar garage | TABLIST_HEADERS con PosX/Y/Z/RZ de Ubic 1 y 2 del garage, mas "Mi Ubicacion" y "Eliminar" | Opcion "Garage" del Dialog 177 (solo si IsGarage) |
| **179** | Editar coordenada garage | Input con valor actual del eje | Opcion de edicion de coordenada en Dialog 178 |
| **180** | Editar coordenada tele | Input con valor actual del eje | Opcion de edicion de coordenada en Dialog 177 |
| **181** | Ver/editar llaves | TABLIST_HEADERS con "Tipo de Propiedad" y "ID de [Tipo]" | Opcion 3 del Dialog 175 |
| **182** | Editar ID de llaves | Input con ID actual del dueno | Opcion "ID de Propiedad" del Dialog 181 |

### Flujo de navegacion

```
/Editar Tele [ID]
       |
     175 ──► 176 (editar nombre) ──► 175 (vuelta)
       |       └── input invalido ──► 176 (reintenta)
       |
       ├──► 177 (ubicaciones)
       |       ├──► 180 (editar eje) ──► 177 (vuelta)
       |       |       └── input invalido ──► 180 (reintenta)
       |       ├──► 178 (garage, si existe)
       |       |       ├──► 179 (editar eje) ──► 178 (vuelta)
       |       |       └── eliminar garage ──► 177
       |       └── "Mi Ubicacion" ──► 177
       |
       ├──► 181 (llaves)
       |       ├── cambiar tipo ──► 181
       |       └──► 182 (editar ID) ──► 181 (vuelta)
       |               └── cancelar ──► 181
       |
       └──► eliminar tele (accion directa, sin sub-dialog)
```

## Funciones nuevas creadas durante el refactor

Estas funciones no existian en el codigo original — se crearon para extraer logica inline repetida de main.pwn:

| Funcion | Archivo:linea | Que hace | Extraido de |
|---------|---------------|----------|-------------|
| `SetTeleTipo(teleid, tipo)` | teles_main.pwn:588 | Establece si un tele es de banco (0) u hotel (1), limpiando el flag contrario | `/Tele Tipo {Banco, Hotel}` (ambos branches, antes inline) |
| `IrTele(playerid, teleid)` | teles_main.pwn:605 | Teletransporta al jugador a la posicion/mundo/interior del tele y envia mensaje | `/IrTele` (antes inline en main.pwn) |
| `AsignarTelePropietario(teleid, tipo, tipoid)` | teles_main.pwn:615 | Asigna dueno a ambos lados del par de teles, limpiando flags previos | `/TeleP` (3 branches casi identicos unificados) |

## Notas de implementacion

### Proceso de verificacion de return-behavior

Durante la extraccion de los 4 comandos de `OnPlayerCommandTelesMapper`, se analizo si los bloques originales tenian `return 1` explicito para evitar romper la cadena:

| Comando | Original | Decision | Fundamento |
|---------|----------|----------|------------|
| `/IrTele` | Sin return explicito | Se agrego `return 1` | Ningun comando subsiguiente comparte prefijo `/IrTele ` |
| `/TelePos` | Sin return explicito | Se agrego `return 1` | `/TelePos ` no colisiona con otros comandos |
| `/Borrar Tele` | Sin return explicito | Se agrego `return 1` | `strcmp` exacto, sin riesgo de falsos positivos |
| `/TeleP` | Sin return explicito | Se agrego `return 1` | `strfind` + espacio, aislado de otros comandos |

Fue seguro agregar `return 1` porque ningun comando subsiguiente en la cadena original comparte prefijo con estos, y los dispatchers devuelven `return 0` si no hay match.

### Codigo muerto eliminado

En la segunda pasada se eliminaron aprox. **133 lineas de codigo muerto** de main.pwn correspondientes a los bloques originales de `/IrTele`, `/TelePos`, `/Borrar Tele` y `/TeleP`.

**Leccion aprendida:** Despues de extraer un bloque a un dispatcher, verificar SIEMPRE que el bloque original fue removido, no solo interceptado.

## Observaciones / deuda tecnica pendiente

### Game loop sin refactorizar

Dos bloques de logica de teles quedan inline en main.pwn por ser parte del game loop:

1. **OnPlayerPickUpDynamicPickup** (main.pwn ~2628-2656): Detecta pickup tipo TELE, setea `InPickupTele`, posiciones, mundo. Entry point de toda interaccion fisica.

2. **OnPlayerKeyStateChange** (main.pwn ~3515-3567): Entrada al tele via tecla — peaje, banco, hotel, negocio, casa. Logica de teletransporte condicional.

Ambos son candidatos para un pass dedicado y separado en el futuro.

### Bridging cross-system

El puente con houses (`IsPlayerNearGarage` → fallback → `IsPlayerNearGarageEx`, main.pwn ~3751-3753) se mantiene sin tocar. Es un consumidor externo legitimo de la API publica (`IsPlayerNearGarageEx` vive en teles_utils.pwn).

### Errores ortograficos en strings del sistema

| Ubicacion | String actual | Error | Correccion |
|-----------|--------------|-------|------------|
| teles_commands.pwn:103 | `"Ahora este tele es la entrada un banco."` | Falta "de" | `"Ahora este tele es la entrada de un banco."` |
| teles_commands.pwn:107 | `"Ahora este tele es la entrada un hotel."` | Falta "de" | `"Ahora este tele es la entrada de un hotel."` |

