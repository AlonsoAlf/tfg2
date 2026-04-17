import 'dart:io';
import 'utils.dart/utils.dart';

void main() async {
  DataBase.instalacion();
  Map<String, String> datos = {};
  String pantalla = Controladormenu.inicio;
  bool ejecutando = true;
  while (ejecutando) {
    switch (pantalla) {
      case "pantallaPrincipal":
        pantalla = await Controladormenu.pantallaPrincipal();
        break;
      case "pantallaInicioSesion":
        pantalla = await Controladormenu.pantallaInicioSesion(datos);
        break;
      case "pantallaRegistro":
        pantalla = await Controladormenu.pantallaRegistro();
        break;
      case "menuAcciones":
        pantalla = await Controladormenu.menuAcciones(datos);
        break;
      case "añadir":
        pantalla = await Controladormenu.introducirData();
        break;
      case "gestionar":
        pantalla = await Controladormenu.mostrarCuentas();
        break;
      case "salir":
        stdout.writeln("Saliendo");
        ejecutando = false;
        break;
    }
  }
}
