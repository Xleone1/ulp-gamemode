# Sistema de Trabajos — Clean Architecture

## Proposito

Sistema de trabajos civiles: pescador (PESCA) y vendedor de moviles (VENDEDOR_MOVIL). Los jugadores pueden obtener/renunciar a un trabajo via `/Trabajar` en un pickup, pescar y vender peces, o vender moviles a otros jugadores. Los trabajos se almacenan en memoria (PlayersData[][Job]) sin persistencia en DB.

## Estructura de archivos

| Archivo | Contenido | Patron |
|---------|-----------|--------|
| `jobs_data.pwn` | Carga de pickups: LoadJobPickupsPesca() y LoadJobPickupsVendedorMovil(). Define los puntos de interaccion fisica (get, vender, pescar) en el mapa. Se llama desde OnGameModeInit en orden especifico para preservar indices MAX_PICKUP_INFO. | x_data |
| `jobs_main.pwn` | Logica core: TogglePlayerJob, Fish, SellFish, OfferPhone, AcceptPhoneOffer, ShowJobHelp, IncrementWorkHours, LoadJobs. Toda funcion que modifica estado del jugador o del sistema de trabajos. | x_main |
| `jobs_commands.pwn` | Comandos del jugador (OnPlayerCommandJobs). Cada comando es un branch else-if dentro del dispatcher, que delega a funciones en jobs_main.pwn. | x_commands |

**Orden de include** (respeta resolucion top-to-bottom de Pawn):
```
jobs_data.pwn → jobs_main.pwn → jobs_commands.pwn
```

## Comandos

| Comando | Sintaxis | Permisos | Descripcion |
|---------|----------|----------|-------------|
| `/Ayuda Trabajo` | `/Ayuda Trabajo` | Cualquiera con trabajo activo | Mustra comandos disponibles segun el trabajo actual (pesca o vendedor) |
| `/Trabajar` | `/Trabajar` | Cualquiera cerca de un pickup de trabajo | Asigna o renuncia al trabajo correspondiente al pickup donde esta parado el jugador |
| `/Pescar` | `/Pescar` | Trabajo PESCA, en zona de pesca | Intenta pescar (usa IntentarAccion). Si exito, marca JobBonus=true y marca checkpoint hacia el punto de venta |
| `/Vender Peces` | `/Vender Peces` | Trabajo PESCA, en punto de venta | Vende los peces por $800 si JobBonus=true |
| `/Vender Movil` | `/Vender Movil [ID] [Precio] [Numero]` | Trabajo VENDEDOR_MOVIL | Ofrece un movil a otro jugador. Si Numero=0, se asigna numero aleatorio |
| `/Aceptar Movil` | `/Aceptar Movil` | Cualquiera con oferta activa | Acepta la oferta de compra de un movil. Descuenta dinero y asigna el telefono |

## Pickups y orden de carga

Los pickups de trabajos se cargan en OnGameModeInit en este orden especifico para preservar los indices MAX_PICKUP_INFO originales:

1. `LoadJobPickupsPesca()` — indices 0, 1, 2 (get, vender, pescar)
2. `LoadNonJobPickups()` — indices 3-12 (vehiculos, trenes, camaras, supermercados)
3. `LoadJobPickupsVendedorMovil()` — indice 13 (get vendedor movil)

### Indices resultantes

| Bloque original | Bloque migrado | Indice MAX_PICKUP_INFO |
|----------------|----------------|------------------------|
| PESCA get | LoadJobPickupsPesca() — pickup 1 | 0 |
| PESCA vender | LoadJobPickupsPesca() — pickup 2 | 1 |
| PESCA pescar | LoadJobPickupsPesca() — pickup 3 | 2 |
| Ambulancia exit | LoadNonJobPickups() | 3 |
| Furgon CNN exit | LoadNonJobPickups() | 4 |
| Camion SWAT exit | LoadNonJobPickups() | 5 |
| Vagon 1 exit | LoadNonJobPickups() | 6 |
| Vagon 2 exit | LoadNonJobPickups() | 7 |
| Vagon 3 exit | LoadNonJobPickups() | 8 |
| Camaras LS | LoadNonJobPickups() | 9 |
| Camaras SF | LoadNonJobPickups() | 10 |
| Supermercado SF | LoadNonJobPickups() | 11 |
| Supermercado LS | LoadNonJobPickups() | 12 |
| VENDEDOR_MOVIL get | LoadJobPickupsVendedorMovil() | 13 |

## Variables

Definidas en `variables/v_jobs.pwn`:

| Simbolo | Tipo | Proposito |
|---------|------|-----------|
| `JobsEnum` | enum | NameJob[MAX_FACCION_NAME], pickupidGet |
| `Jobs[MAX_JOB][JobsEnum]` | array global | Datos de cada trabajo (nombre, pickup ID de obtencion) |
| `JobsDataEnum` | enum | PESCA_PickupidPescar, PESCA_PickupidVender |
| `JobsData[JobsDataEnum]` | array global | Indices de pickups de pesca en PickupInfo[] |

## Bugs encontrados durante la migracion

### Indices MAX_PICKUP_INFO (potencial, verificado correcto)

Durante la migracion se analizo si la division de LoadInfoPickups() en tres funciones (LoadJobPickupsPesca, LoadNonJobPickups, LoadJobPickupsVendedorMovil) alteraba los indices MAX_PICKUP_INFO. Se confirmo que el orden de llamada preserva exactamente los indices originales para los 14 bloques.

### JobsData almacenaba SA-MP pickup ID en vez de indice (CORREGIDO)

Las lineas originales en LoadJobPickupsPesca() asignaban:
```pawn
JobsData[PESCA_PickupidVender] = PickupInfo[MAX_PICKUP_INFO][PickupId];  // bug: almacena SA-MP ID
JobsData[PESCA_PickupidPescar] = PickupInfo[MAX_PICKUP_INFO][PickupId];  // bug: almacena SA-MP ID
```

Esto causaba que en Fish() y SellFish() se usara el SA-MP pickup ID como indice de PickupInfo[], provocando "Array index out of bounds" en runtime ya que PickupInfo tiene solo 50 slots.

**Correccion:**
```pawn
JobsData[PESCA_PickupidVender] = MAX_PICKUP_INFO;  // almacena el indice del array
JobsData[PESCA_PickupidPescar] = MAX_PICKUP_INFO;  // almacena el indice del array
```

Este bug existia en el codigo original de main.pwn anterior a la migracion (pre-existente, no introducido por el refactor).

### Orden de los miembros en JobsDataEnum

El enum JobsDataEnum declara PESCA_PickupidPescar=0 y PESCA_PickupidVender=1, pero en LoadJobPickupsPesca() el orden de asignacion es Vender primero (indice MAX_PICKUP_INFO=1) y Pescar despues (indice MAX_PICKUP_INFO=2). Esto significa que PESCA_PickupidPescar (JobsData[0]) = 2 y PESCA_PickupidVender (JobsData[1]) = 1.

No es un bug — funciona correctamente — pero la nomenclatura del enum no refleja el orden de asignacion fisica de los pickups, lo que puede ser confuso.

## Call-sites externos que quedan en main.pwn

| Ubicacion | Que hace | Sistema externo |
|-----------|----------|-----------------|
| main.pwn:606 (MostrarHora) | Llama IncrementWorkHours(i) | Timer de hora |
| main.pwn:8671 (OnPlayerCommandText) | Llamada al dispatcher OnPlayerCommandJobs | Cualquier comando de jugador |

## Deuda tecnica pendiente

- Los comandos `/Estado Trabajo` y `/Estado Taxi` (faccion) no fueron migrados — permanecen en main.pwn por estar fuera del alcance de esta migracion.
