# Sistema Forum Bridge — Integracion con API externa

## Proposito

Sistema de puente entre el servidor SA-MP y un foro externo (NodeBB). Crea cuentas de usuario en el foro de forma automatica y asincrona cada vez que un jugador se registra en el servidor. La comunicacion se realiza via HTTP POST a una API externa construida en FastAPI.

## Estructura de archivos

| Archivo | Contenido | Patron |
|---------|-----------|--------|
| `forum_bridge.pwn` | Configuracion runtime, envio de requests HTTP, callbacks de respuesta. Contiene toda la logica del sistema en un solo archivo ya que no tiene dependencias SQL ni comandos propios. | x_main |

**Orden de include** (se incluye via `s_main.pwn`):
```
s_main.pwn → systems/forum/forum_bridge.pwn
```

## Arquitectura

```
┌──────────────┐      HTTP POST (pawn-requests)     ┌──────────────┐      HTTP POST      ┌──────────────┐
│   SA-MP      │ ──────────────────────────────────> │   API     │ ──────────────────> │   NodeBB     │
│   (Pawn)     │     JSON: username, password, email  │   API        │   SERVER_API_KEY    │   Write API  │
│              │ <────────────────────────────────── │  (FastAPI)   │ <────────────────── │              │
└──────────────┘      Codigo de respuesta HTTP        └──────────────┘      Respuesta      └──────────────┘
```

- **SA-MP (Pawn):** Envia los datos de registro (nombre, contraseña, email) via pawn-requests.
- **API externa (FastAPI):** Recibe la peticion, autentica con `SERVER_API_KEY` y ejecuta la creacion de usuario en NodeBB.
- **NodeBB Write API:** Crea la cuenta de usuario en el foro.

## Flujo de registro detallado

1. El jugador responde el dialogo 2 (registro) ingresando una contraseña.
2. La contraseña en texto plano se almacena en `PlayersDataOnline[playerid][TempPassword]`.
3. Se ejecuta `bcrypt_hash(playerid, "SetPlayerPassword", inputtext, BCRYPT_COST)` (asincrono).
4. El callback `SetPlayerPassword` obtiene el hash y lo guarda en `PlayersData[playerid][Password]`.
5. Se llama a `Forum_CreateUser(playerid)`.
6. Se construye el JSON body: `{"username": "...", "password": "...", "email": "..."}`.
7. Se envia un HTTP POST asincrono a la API externa con headers `X-API-Key` y `Content-Type: application/json`.
8. `TempPassword` se borra inmediatamente (`format(..., "")`).
9. El registro continua (dialogo 3: sexo, luego dialogo 15: edad, luego dialogo 4: ciudad).
10. Si la peticion falla, se registra un error en consola pero el registro no se ve afectado.

## Funciones publicas

| Funcion | Parametros | Descripcion |
|---------|------------|-------------|
| `Forum_CreateUser(playerid)` | `playerid` - ID del jugador | Envia los datos de registro a la API externa. Retorna 0 si el sistema esta deshabilitado o hay un error de validacion, 1 si la peticion se envio correctamente. |
| `ForumBridge_LoadConfig()` | (ninguno) | Carga la configuracion desde `Misc/forum_bridge.cfg`. Se llama desde `OnGameModeInit`. Retorna 1 si la carga fue exitosa, 0 si hubo error. |

## Callbacks internos

| Callback | Tipo | Descripcion |
|----------|------|-------------|
| `OnForumBridgeCreateUser(Request:id, Node:node, statusCode)` | pawn-requests | Se ejecuta cuando la API externa responde. Registra un error si el codigo de respuesta no es 200 o 201. |
| `OnRequestFailureForumBridge(Request:id, errorCode, errorMessage[], len)` | pawn-requests | Se ejecuta cuando hay un error de conexion (timeout, DNS, etc.). Registra el error en consola. |

## Variables estaticas del modulo

| Variable | Tipo | Tamano | Descripcion |
|----------|------|--------|-------------|
| `g_ForumBridgeEnabled` | `bool` | - | Habilita/deshabilita el sistema |
| `g_ForumBridgeApiKey` | `string` | 128 | Clave API para el header X-API-Key |
| `g_ForumBridgeApiUrl` | `string` | 256 | URL base de la API externa |
| `g_ForumBridgeCreateUserPath` | `string` | 128 | Ruta del endpoint de creacion de usuarios |
| `g_ForumBridgeClient` | `RequestsClient` | - | Cliente HTTP reutilizado (lazy initialization) |

## Constantes de configuracion

| Constante | Valor | Archivo | Descripcion |
|-----------|-------|---------|-------------|
| `FORUM_BRIDGE_CFG_PATH` | `"Misc/forum_bridge.cfg"` | `c_main.pwn` | Ruta al archivo de configuracion |

## Dependencias

| Dependencia | Incluida en | Uso |
|-------------|-------------|-----|
| [pawn-requests](https://github.com/Southclaws/pawn-requests) | `main.pwn` (`#include <requests>`) | Cliente HTTP y manejo de JSON |
| PlayersData | `v_users.pwn` | Acceso a `Email` del jugador |
| PlayersDataOnline | `v_users.pwn` | Acceso a `NameOnline` y `TempPassword` |

## Manejo de errores

- **Archivo de configuracion no existe:** Se imprime un warning y el sistema queda deshabilitado.
- **Configuracion incompleta (habilitado pero faltan valores):** Se imprime que falta cada valor y el sistema se deshabilita automaticamente.
- **TempPassword vacia:** Se registra un error con el nombre del jugador y la funcion retorna 0.
- **Request HTTP falla al enviar:** Se registra un error con el nombre del jugador.
- **API externa devuelve error HTTP:** Se registra el codigo de respuesta en consola.
- **Error de conexion:** Se registra el codigo y mensaje de error.

El sistema **nunca crashea** el gamemode por mala configuracion o errores de conexion.

## Registro en consola

Al iniciar el servidor, si el sistema esta habilitado:

```
[ForumBridge] Enabled: Yes
[ForumBridge] API URL: http://127.0.0.1:8000
[ForumBridge] Endpoint: /api/v1/users
[ForumBridge] API Key: configured
```

Si esta deshabilitado:

```
[ForumBridge] Enabled: No
```

> **Nota:** La API key nunca se imprime en la consola por razones de seguridad.

## Como habilitar/configurar

1. Editar `scriptfiles/Misc/forum_bridge.cfg`:
   ```ini
   forum_bridge_enabled=1
   forum_bridge_api_url=http://127.0.0.1:8000
   forum_bridge_api_key=tu_clave_api
   forum_bridge_create_user_path=/api/v1/users
   ```

2. Reiniciar el servidor.

3. Verificar en la consola que aparezca `[ForumBridge] Enabled: Yes`.

## Mejoras futuras

- **Sincronizacion de email:** Recopilar email durante el registro y enviarlo a la API externa para crear cuentas con email verificado.
- **Sincronizacion de contrasenas:** Cuando el jugador cambie su contraseña en el servidor, sincronizar el cambio con el foro.
- **Vinculacion de cuentas:** Permitir a jugadores existentes vincular su cuenta del servidor con una cuenta del foro existente.
- **Sincronizacion de login:** Cuando el jugador se loguee en el foro, verificar contra la base de datos del servidor.
- **Sincronizacion de datos de perfil:** Sincronizar datos como nombre, skin, faccion, nivel, etc. con el perfil del foro.
- **Retry automatico:** Si la peticion HTTP falla, reintentar automaticamente con backoff exponencial.
- **Cola de mensajes:** Enviar peticiones fallidas a una cola para reintentarlas mas tarde.
