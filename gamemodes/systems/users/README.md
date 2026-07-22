# Sistema de Usuarios — Login contra API

## Proposito

Maneja el inicio de sesion contra una API HTTPS externa (FastAPI) usando el
plugin `pawn-requests`. Reemplaza la autenticacion local basada en MySQL +
bcrypt por una API centralizada. El sistema anterior (DataUserLoad, bcrypt,
SetPlayerPassword) sigue existiendo para flujos administrativos (UnBanUser)
y se conserva como fallback si la API esta deshabilitada.

## Estructura de archivos

| Archivo | Contenido | Patron |
|---------|-----------|--------|
| `users_data.pwn` | `DataUserLoad()` y `DataUserSave()` — usados solo por admin (UnBanUser) y como fallback. | x_data |
| `users_utils.pwn` | `ValidatePlayerPassword()`, `GetPasswordErrorText()`, `CommonPasswords`, `IsPlayerLogued`, `IsAccountExist`, etc. La validacion de password se conserva del sistema viejo. | x_utils |
| `users_main.pwn` | `DataUserClean()`, `SaveDatosPlayerDisconnect()`, `OnPasswordChecked`/`SetPlayerPassword`/`ContinueLoginFlow` (usados por el fallback), `ShowPlayerLogin()`, `ShowPlayerRegister()`, `ShowPlayerLoginApi()` (nuevo), `ShowPlayerEmailChange()`. | x_main |
| `users_api.pwn` | Cliente `RequestsClient`, loader de `scriptfiles/Misc/api_auth.cfg`, callbacks `OnAuthLogin`/`OnAuthRegister`/`OnCharacterLoad`/`OnCharacterCreate`/`OnRequestFailure`, mapeo JSON CharacterFull → `PlayersData`. | nuevo (x_api) |

## Configuracion

`scriptfiles/Misc/api_auth.cfg`:

```
users_api_enabled=1
users_api_key=changeme
users_api_base_url=https://api.api.example.com/
users_api_login_path=/api/v1/auth/login
users_api_register_path=/api/v1/auth/register
users_api_char_get_path=/api/v1/characters/%d
users_api_char_create_path=/api/v1/characters/create
```

Si `users_api_enabled=0` el gamemode cae automaticamente al sistema viejo
(MySQL + bcrypt). Esto es util para development o disaster-recovery.

## Flujo del login

```
OnPlayerConnect
  -> DataUserClean (limpia PlayersData y TempAccountID/TempCharList)

OnPlayerRequestClass (State == 0)
  -> ShowPlayerLoginApi (dialog 1 password, titulo "Login - <Nombre>")

OnDialogResponse case 1
  -> ValidatePlayerPassword (filtra claves debiles)
  -> UsersApi_Login
       POST /auth/login {username, password}
       Header: X-API-Key
       Callback: OnAuthLogin
         404  -> usersApi_DoRegister (mismo password)
         401  -> ShowPlayerLoginApi(false) + "Clave incorrecta"
         200  -> Parsear account_id y characters[]:
                   - si no hay personajes -> dialog 4 (crear)
                   - si hay  -> dialog 3 (seleccionar)
         otro -> error generico, reabrir dialog 1
  -> OnRequestFailure (timeout, DNS, etc)
       -> ShowPlayerLoginApi(true) + "No se pudo conectar..."

OnDialogResponse case 3 (seleccionar personaje)
  -> Si listitem apunta a "Crear Nuevo Personaje" -> dialog 4
  -> Si listitem apunta a personaje existente:
       usersApi_LoadCharacter(characterId)
         GET /api/v1/characters/<id>
         Callback: OnCharacterLoad
           200 -> usersApi_ApplyCharacter + UsersApi_FinalizeLogin
           otro -> error, reabrir dialog 3

OnDialogResponse case 4 (crear personaje)
  -> IsValidNameApellido (formato Nombre_Apellido)
  -> usersApi_CreateCharacter
       POST /api/v1/characters/create {account_id, name}
       Callback: OnCharacterCreate
         200/201 -> usersApi_ApplyCharacter + UsersApi_FinalizeLogin
         409 (nombre en uso) u otro -> mostrar detalle, reabrir dialog 4

UsersApi_FinalizeLogin
  -> Si Email == "No" -> gate de email (ShowPlayerEmailChange + PendingEmailGate)
  -> Si no -> ContinueLoginFlow (spawn, weapons, agenda, etc.)

ContinueLoginFlow (existente, sin cambios)
  -> Spawn, mundo virtual, vida, dinero, armas, etc.
```

## Variables globales nuevas (v_users.pwn)

```pawn
new TempAccountID[MAX_PLAYERS];
new TempCharList[MAX_PLAYERS][3][MAX_PLAYER_NAME];
new TempCharIDs[MAX_PLAYERS][3];
new TempCharLevel[MAX_PLAYERS][3];
```

`TempCharIDs[i] == 0` indica slot vacio. Maximo 3 personajes por cuenta
(constante `MAX_CHARS_PER_ACCOUNT`).

## Mapeo JSON CharacterFull -> PlayersData

El campo del JSON esperado es snake_case:

| JSON | PlayersData | Notas |
|------|-------------|-------|
| `account_id` | `TempAccountID[playerid]` | viene en /auth/login, no en /characters/{id} |
| `name` | `NameOnlineFix` | name character (no el nick de SA-MP) |
| `email` | `Email` | gate de email si == "No" o vacio |
| `skin` | `Skin` | int |
| `money` | `Dinero` | int |
| `bank` | `Banco` | int |
| `health` | `Vida` (Float) | int, convertido con `float()` |
| `armor` | `Chaleco` (Float) | int, convertido con `float()` |
| `interior` | `Interior` | int |
| `world` | `World` | int |
| `sex` | `Sexo` | 0/1 |
| `age` | `Edad` | 18-60 |
| `city` | `Ciudad` | 0=LS, 1=SF |
| `faction` | `Faccion` | int |
| `rank` | `Rango` | int |
| `level` o `hours_played` | `HoursPlaying` | int |
| `deaths` | `DeahtCount` | int |
| `kills` | `KilledCount` | int |
| `phone` | `Phone` | int |
| `fatigue` | `Cansansio` | int 0-54 |
| `house_id` | `House` | int (HouseId del repo) |
| `business_id` | `Negocio` | int |
| `car_id` | `Car` | int (vehicleIndex) |
| `rent_id` | `Alquiler` | int |
| `walk_style` | `MyStyleWalk` | int |
| `talk_style` | `MyStyleTalk` | int |
| `fighting_style` | `Habilidad` | int |
| `job` | `Job` | int |
| `description_id` | `Description` | int |
| `description_color` | `DescriptionColor` | int |
| `admin_level` | `Admin` | int |
| `warns` | `Warn` | int |
| `jail_time` | `Jail` | int |
| `jail_type` | `IsInJail` | int |
| `pos_x/y/z/a` | `Spawn_X/Y/Z/ZZ` (Float) | posicion |
| `girlfriend` | `GirlFreind` | string |
| `myip` | `MyIP` | string (16) |
| `description` | `DescriptionString` | string |
| `weapons` | `WeaponS[]` + `AmmoS[]` | array de `{id, ammo}`, max 13 |
| `in_tutorial` | `InTutorial` | bool |
| `enable_description` | `EnableDescription` | bool |
| `description_custom` | `DescriptionSelect` | bool |

Los campos no provistos por la API quedan en sus defaults de `DataUserClean`
(generalmente 0 o `false`).

## SSL / Certificados

El plugin `pawn-requests` 0.8.7 (y la version actual) **no expone**
`REQUESTS_OPTION_SSL_VERIFYPEER`. El plugin carga la CA bundle del sistema
(`/etc/ssl/certs/ca-certificates.crt` en Linux) y verifica la cadena de
certificados contra esa. La verificacion de hostname depende del backend
(cpprestsdk) y puede no activarse explicitamente.

**Implicacion practica**: con un certificado de Let's Encrypt (CA publica) y
un hostname correcto, las requests HTTPS funcionan sin configuracion extra.
Si la API usa un cert autofirmado, hay que:

1. Agregar la CA al bundle del sistema operativo, o
2. Parchear el plugin `pawn-requests` para que use `load_verify_file()` con
   un bundle custom.

**No es posible** desactivar la verificacion peer desde pawn sin parchar el
plugin.

## Compatibilidad con el sistema viejo

`DataUserLoad()` y `DataUserSave()` se conservan intactos porque los usa
`UnBanUser()` (admin) y se referencian desde varios sistemas (vehiculos,
facciones, etc.). El login normal ahora no los llama; los jugadores
existen solo en la API.

`ShowPlayerLogin()`, `ShowPlayerRegister()`, `OnPasswordChecked()`,
`SetPlayerPassword()`, `IsPasswordMatches()`, `ChangeMyPassword()` y
`ChangeAccountPassword()` siguen existiendo y son el camino cuando la API
esta deshabilitada (`users_api_enabled=0`).

`bcrypt_verify`/`bcrypt_hash` siguen usandose para cambio de password
desde el panel de cuenta (case 16, 17) y para admin (ChangeAccountPassword).
Solo el camino del login/registro inicial deja de llamarlos.

## Limitaciones conocidas

- Si la API esta caida al momento del login, el jugador queda en el dialog
  1. `OnRequestFailure` reabre el dialog automaticamente, pero no hay
  reintento automatico: el jugador debe tipear la password de nuevo.
- No hay timeout nativo de pawn-requests. Si la API cuelga sin responder,
  el thread queda esperando.
- El plugin no verifica hostname explicitamente (depende de cpprestsdk).
  Con un cert wildcard de Let's Encrypt funciona; con certs mal
  configurados podria pasar la verificacion de cadena pero fallar la
  comunicacion efectiva.
- El listado de personajes (`characters[]` en /auth/login) puede venir
  como un stub `{id, name, level}` o como un CharacterFull completo. El
  codigo actual solo lee `id`, `name` y `level` del stub. El CharacterFull
  se trae aparte con `GET /api/v1/characters/<id>` al seleccionar.
- El maximo de 3 personajes es enforced solo en el cliente (UI y el
  limite de `MAX_CHARS_PER_ACCOUNT` en el loop). La API debe enforcearlo
  tambien.

## Pruebas manuales

1. Levantar la API y verificar que responde:
   `curl -sk https://api.api.example.com/api/v1/auth/login -H 'X-API-Key: ...' -d '{"username":"X","password":"X"}'`
2. Compilar: `cd gamemodes && ./compile` — debe dar 16 warnings, 0 errors.
3. Iniciar sesion con un usuario nuevo: debe crear la cuenta via 404→register.
4. Crear el primer personaje: POST /characters/create debe responder 201.
5. Reconectar: 200 con `characters[]` no vacio → debe mostrar dialog 3.
6. Seleccionar personaje existente: GET /characters/<id> debe traer
   CharacterFull y spawnear al jugador.
