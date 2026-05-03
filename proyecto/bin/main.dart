import 'dart:io';
import 'utils.dart/utils.dart';

void main() async {
  DataBase.instalacion();
  String pantalla = Controladormenu.inicio;
  while (true) {
    switch (pantalla) {
    case "pantallaPrincipal":
      pantalla =  Controladormenu.pantallaPrincipal();
      break;
    case "pantallaInicioSesion":
      pantalla = await Controladormenu.pantallaInicioSesion();
      break;
    case "pantallaRegistro":
      pantalla = await Controladormenu.pantallaRegistro();
      break;
    case "menuAcciones":
      pantalla = Controladormenu.menuAcciones();
      break;
    case "addCuenta":
      pantalla = await Controladormenu.addCuenta();
      break;
    case "gestionar":
      pantalla = await Controladormenu.opcionesGestionCuenta();
      break;
    case "opcionesGestionCuenta":
      pantalla = await Controladormenu.opcionesGestionCuenta();
      break;
    case "borrarCuenta":
      pantalla = await Controladormenu.cuentaBorrada();
      break;
    case "modificarCuenta":
      pantalla = await Controladormenu.cuentaModificada();
      break;
    case "comprobar":
      pantalla = await Controladormenu.comprobarPassword();
      break;
    case "salir":
      stdout.writeln("""
        Saliendo
        """);
      exit(0);
    }
  }
}
