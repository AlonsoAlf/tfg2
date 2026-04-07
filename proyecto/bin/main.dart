import 'dart:io';
import 'utils.dart/utils.dart';
void main()async {
await DataBase.instalacion();
Map<String,String> datos = {};
String pantalla = Controladormenu.inicio;
bool ejecutando = true;
while(ejecutando){
switch(pantalla){
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
    pantalla = await Menuacciones.menuAcciones();
    break;
    case "introducirData":
    pantalla = await Menuacciones.introducirData();
    break;
    case "salir":
    stdout.writeln("Saliendo");
    ejecutando = false;
    break;
  }
}
}
