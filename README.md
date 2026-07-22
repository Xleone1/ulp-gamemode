# Union Latin Players (ULP) - Legacy Gamemode

Gamemode de rol en español para **SA-MP / open.mp**. Desarrollado en Pawn.

## Requisitos

- [open.mp](https://open.mp) server (o SA-MP 0.3.7+)
- [pawncc](https://github.com/pawn-lang/compiler) 3.10.10
- [MySQL](https://www.mysql.com/) (conexión vía `a_mysql`)
- Conexión a internet para funcionalidades API

## Estructura

```
gamemodes/
├── main.pwn                # Entry point del gamemode
├── constants/              # Constantes globales
├── variables/              # Variables y enums globales
├── utils/                  # Utilidades generales
├── systems/                # Sistemas del gamemode
│   ├── users/              # Sistema de usuarios (login, registro, API)
│   ├── vehicles/           # Sistema de vehículos
│   ├── houses/             # Sistema de casas
│   ├── business/           # Sistema de negocios
│   ├── bombas/             # Sistema de bombas
│   ├── audio_stream/       # Sistema de reproducción de MP3
│   ├── staff/              # Sistema de administración
│   ├── jobs/               # Sistema de trabajos
│   ├── factions/           # Sistema de facciones
│   ├── forum/              # Bridge con foro
│   ├── facebook/           # Identidad oculta (no ves el nombre hasta presentarse)
│   └── ...                 # Más sistemas
├── filterscripts/
│   └── mapeos.pwn          # Mapeos personalizados
└── scriptfiles/
    └── Misc/               # Archivos de configuración
```

## Características principales

- Registro y login con API externa (con fallback MySQL)
- Sistema de personajes con múltiples slots
- Vehículos con personalización, taller y radio
- Casas y negocios con sistema de llaves y refrigerador
- Sistema de trabajos (pesca, vendedor móvil, etc.)
- Facciones (policía, bomberos, gobierno, etc.)
- Sistema de bancos, carteras y bolsillos
- Sistema de bombas
- Reproducción de MP3 a jugadores cercanos (/playmp3, /pararmp3)
- Sistema de mapeo con objetos, puertas, peajes y parqueos
- Deathmatch y carreras
- Tutorial interactivo
- Sistema de identidad oculta (no ves el nombre de otro jugador hasta que se presentan)
- Bridge con foro externo (HTTP requests)
- Anti-cheat integrado

## Nota legal

Archivo histórico de una versión de desarrollo basada en la gamemode comunitaria Union Latin Players (ULP). Este repositorio busca preservar una base de código libre para aprendizaje y experimentación de la comunidad de open.mp / SA-MP.

Este repositorio contiene código desarrollado por múltiples autores a lo largo del tiempo. Los derechos de autor corresponden a sus respectivos autores y colaboradores.

La publicación de este repositorio busca preservar una base histórica de desarrollo y permitir que la comunidad pueda continuar experimentando y aprendiendo sobre esta gamemode.

Si algún autor o titular de derechos considera que alguna parte del contenido no debería estar publicada, puede contactar al mantenedor del repositorio para revisar la situación.
