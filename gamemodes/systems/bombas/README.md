# Sistema de Bombas — Clean Architecture

## Proposito

Sistema de control de bombas: plantar (vehiculo o piso), detonar, desactivar y verificar bombas. Requiere faccion SICARIOS o permisos de admin. Las bombas se persisten en MySQL y se cargan al iniciar el servidor.

## Estructura de archivos

| Archivo | Contenido | Patron |
|---------|-----------|--------|
| `bombas_main.pwn` | Logica core: ShowBombas, AddBomba, RemoveBomba, DesactivarBomba, ActivarBomba. Toda funcion que ejecuta accion sobre el estado del sistema. | x_main |
| `bombas_data.pwn` | Persistencia: SaveBombaToDB, ClearBombaFromDB. Cada funcion encapsula un `mysql_format` + `mysql_query`. Nunca se llama mysql_query directamente desde main. | x_data |
| `bombas_utils.pwn` | Helpers puros sin side effects: IsPlayerNearBomba, IsVehicleHaveBomba, IsPlayerNearBombaEx. Solo leen estado, nunca modifican nada. | x_utils |
| `bombas_commands.pwn` | Comandos del jugador (OnPlayerCommandBombas) y respuestas de dialog (OnBombasDialogResponse). Cada comando es un branch else-if dentro del dispatcher. | x_commands |

**Orden de include** (respeta resolucion top-to-bottom de Pawn):
```
bombas_data.pwn → bombas_utils.pwn → bombas_main.pwn → bombas_commands.pwn
```

## Comandos

| Comando | Sintaxis | Permisos | Descripcion |
|---------|----------|----------|-------------|
| `/Poner Bomba` | `/Poner Bomba <tipo>` (tipo: 0-7) | SICARIOS rango ≤ 4, o admin ≥ 8 | Planta bomba en piso (si esta a pie) o en vehiculo (si esta conduciendo) |
| `/Bombas` | `/Bombas` | SICARIOS rango ≤ 4, o admin ≥ 8 | Abre dialog 77 con la lista de bombas activas |
| `/Ver Bomba` | `/Ver Bomba` | SICARIOS rango ≤ 4 | Muestra el numero de control de la bomba mas cercana (rango 1.5) |
| `/Detonar Todas` | `/Detonar Todas` | SICARIOS rango ≤ 1, o admin ≥ 8 | Detona todas las bombas activas con explosion de 10.0 radio |
| `/Desactivar Bomba` | `/Desactivar Bomba` | SICARIOS rango ≤ 4, SFPD/LSPD rango ≤ 6 | Desactiva la bomba cercana. Si la faccion es policial y falla IntentarAccion, la bomba explota |
| `/Desactivar Bomba Todos` | `/Desactivar Bomba Todos` | Admin ≥ 7 | Elimina todas las bombas del servidor |

## Dialogs

| Dialog ID | Que muestra | Disparador |
|-----------|-------------|------------|
| 77 | Lista de bombas activas (DIALOG_STYLE_LIST) con boton "Detonar" | `/Bombas` → ShowBombas() |
| 78 | Mensaje de resultado post-detonacion (exito/error) con boton "Volver" | Dialog 77 al detonar |

Flujo: `/Bombas` → dialog 77 (lista) → seleccionar bomba → detonar → dialog 78 (resultado) → "Volver" → vuelve a dialog 77.

## Notas de implementacion

**Bug encontrado durante la migracion:** El wrapper `/Desactivar` original en main.pwn no tenia `return 1` despues del bloque if/else-if/else. Esto significaba que un `/Desactivar` no reconocido mostraba el mensaje de sugerencia y continuaba al siguiente comando en la cadena. Al extraer al dispatcher, agregar `return 1` unconditional habria cambiado ese comportamiento. La solucion fue no agregar return explicito en el wrapper, permitiendo que caiga a `return 0` al final de la funcion — preservando la compatibilidad con el comportamiento original.

**Regla para futuras migraciones:** Si un bloque original en main.pwn no tenia return explicito, el dispatcher tampoco debe tenerlo. Solo agregar `return 1` cuando el bloque original lo tenia (como retorno de OnPlayerCommandText) o cuando no hay riesgo de que un cmdtext no reconocido necesite caer a otros comandos.

## Observaciones / deuda tecnica pendiente

### Errores ortograficos en strings del sistema

| Ubicacion | String actual | Error | Correccion sugerida |
|-----------|--------------|-------|-------------------|
| bombas_main.pwn:45 | `"El numero de contro de la bomba es #%i."` | Falta "l" en "control" | `"El numero de control de la bomba es #%i."` |
| bombas_main.pwn:103 | `"El numero de contro de la bomba es #%i."` | Mismo error | `"El numero de control de la bomba es #%i."` |
| bombas_commands.pwn:60 | `"Usted no es no puede poner bombas!"` | "no es" sobrante | `"Usted no puede poner bombas!"` |
| bombas_commands.pwn:182 | `"Usted no es no puede desactivar bombas!"` | "no es" sobrante | `"Usted no puede desactivar bombas!"` |

### Comportamiento preexistente no modificado

- `/Ver Bomba` y `/Desactivar Bomba` no tienen bypass de admin — solo funcionan para su faccion especifica (SICARIOS/SFPD/LSPD). Un admin sin faccion no puede usar estos comandos. Comportamiento original, no corregido en este pilot.

### Call-sites externos que quedan en main.pwn

Estas funciones de bombas se llaman desde otros sistemas, no desde comandos propios de bombas:

| Ubicacion | Funcion llamada | Sistema externo | Razon |
|-----------|----------------|-----------------|-------|
| main.pwn:4133-4135 | `PlayersData[playerid][Bombas]++` | Craft/armas con materiales | Crear bomba desde dialog de fabricacion |
| main.pwn:10568-10571 | `IsVehicleHaveBomba()` + `ActivarBomba()` | Puenteo de vehiculo | Si un vehiculo con bomba plantada se puentea, la bomba se activa automaticamente |
| s_vehicles.pwn:927 | `ActivarBomba()` | Sistema de vehiculos | Mismo caso: detonacion por evento de vehiculo |
| s_traffic_items.pwn:68 | `AddBomba()` | Items de transito | Carga de bombas desde DB al iniciar |

Estos call-sites son consumidores de la API publica del sistema (AddBomba, ActivarBomba, etc.) y NO deben moverse a bombas_commands.pwn — son parte de la logica de sus respectivos sistemas.
