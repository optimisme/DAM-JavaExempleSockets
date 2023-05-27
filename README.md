# Exemple Sockets #

En aquest projecte hi ha exemples sockets UDP, TCP i WebSockets en Java

### Instruccions ###

Primer posar en funcionament el servidor

Després, en un o més terminals, posar en funcionament un o més clients (UDP, TCP o WebSockets segons el servidor que correspon)

El servidor UDP s'envia missatges automàticament

El servidor TCP s'envia els missatges de la línia de comandes

El servidor WebSockets pot enviar missatges des de l'eina de comandes o des de l'aplicació client GUI

Els clients WebSockets poden enviar missatges privats a un usuari específic tipus: "to(a82)missatge privat", es poden llistar els usuaris amb "list"

### Compilació i funcionament ###

A Linux i OSX:

```
./build.sh
```

A Windows Powershell:

```
.\build.ps1
```

Or, from Visual Studio Code:

```
"Terminal > Run task > Compile for UNIX"
"Terminal > Run task > Compile for PowerShell"
```

### Llicència ###

Tenir en compte les llicències MIT de "WebSockets" i "slf4j":

[WebSockets](https://github.com/TooTallNate/Java-WebSocket)

[slf4j](https://www.slf4j.org/)