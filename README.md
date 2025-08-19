# Lista de la compra (Shopping List)

[<img src="https://f-droid.org/badge/get-it-on.png"
     alt="Get it on F-Droid"
     height="80">](https://f-droid.org/packages/com.jaimegonzalezfabregas.shoppinglist/)

Or download the latest APK from the [Releases Section](https://github.com/jaimegonzalezfabregas/lista_de_la_compra/releases/latest).


This is a shopping list app, with integrated meals scheduler. It features local sync, that is, synchronization between instances without the need of a central server.


## Architecture

Some offline games (like Minecraft), can be used offline, as a client of other instance, or serve its game to other clients.

*Lista de la compra* can act as server and client simultaneusly, in a _peer to peer_ achitecture.

- When acting as a server, the UI shows all the reachable IP addresses, and also anounces itself using zeroconf/mdns.
- When acting as a client, the UI shows the detected servers, and allows to enter a custom server.

### Use cases
- Padawan level: Use a single app instance to track your grocceries
- Jedi knight level: Share your databases between your family, and syncronize your instances with your home wifi
- Jedi master level: When shopping, turn of the access point (wifi tethering) on one of your smartphones, and connect the remaining instances to that wifi
- Sith level: Install a VPN server on your home or VPS, connect all your smartphones to that VPN.
- Sith lord level: Add the [standalone server](./packages/lista_de_la_compra_server/README.md) to your VPN

## Encryption
Currently, there is no encryption in the network protocol. Please connect only to fully trusted networks while synchronizing the app databases.


## Standalone server
You can host a server in your own LAN. See the instructions in [lista_de_la_compra_server](./packages/lista_de_la_compra_server/README.md).








