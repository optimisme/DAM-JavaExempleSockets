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

Cal el 'Maven' per compilar el projecte
```bash
mvn clean
mvn compile
```

Per executar el projecte a Windows cal
```bash
.\run.ps1 com.project.Main
```

Per executar el projecte a Linux/macOS cal
```bash
./run.sh com.project.Main
```

Per executar un arxiu main directament
```bash
.\run.ps1 com.project.TcpServidor
./run.sh com.project.TcpServidor
```