## vita-lua-examples

This repo contains programs and examples for [vita-lua](https://github.com/Stary2001/vita-lua), mainly intended to be run with vitafm, the bundeled filemanager included with vita-lua.

# Building

Build [vita-lua](https://github.com/Stary2001/vita-lua) with `make BOOTSCRIPT=src/boot/vitafm.lua`.

## UNIX

Run `make` and put `vita-lua-examples.zip` in `cache0:/VitaDefilerClient/Documents`.

## Windows

Zip up this directory and make sure it contains the folder `bin` in it.

Put the resulting zip in `cache0:/VitaDefilerClient/Documents/vita-lua-examples.zip`

# Usage

Mount it on the vita in vitafm, either manually or via vitafm.cfg:

```ini
[mount]
cache0:/VitaDefilerClient/Documents/vita-lua-examples.zip
```
