import 'dart:io';
import '../entities.dart/entities.dart';
abstract class Menuacciones {
  static Future<String> menuAcciones() async{
    String? opcion;
    do{
      stdout.writeln("Seleccione que acción desea hacer:");
      stdout.writeln("1. Añadir usuario y contraseña.");
      stdout.writeln("2. Gestionar contraseñas");
      stdout.writeln("3.Comprobar seguridad contraseña");
      opcion = stdin.readLineSync()?? "";
      if(opcion.isEmpty){
        stdout.writeln("Selecciones una opcion valida");
        continue;
      }
    }while(opcion != "1" && opcion != "2" && opcion != "3");
    switch(opcion){
      case "1":
      return "introducirData";
      case "2":
      return "gestionar";
      case "3":
      return "comprobar";
      default:
      return "menuAcciones";
    }
  }
    static Future<String> introducirData() async {
    Map<String, String> data;
    String? cuenta;
    String? passwordCuenta;
  do{
    stdout.writeln("Introduca el usuario o correo electronico asociado a la cuenta");
    cuenta = stdin.readLineSync() ?? "";
    stdout.writeln("Introduzca la contraseña de la cuenta");
    passwordCuenta = stdin.readLineSync() ?? "";
    if(cuenta.isEmpty || passwordCuenta.isEmpty){
      stdout.writeln("Ningún campo puede quedar vacio, intentelo de nuevo");
    }
  }while(cuenta.isEmpty || passwordCuenta.isEmpty);
  data = {"cuenta": cuenta, "passwordCuenta": passwordCuenta};
  bool existe = await Cuenta.existePassword(data);
  if(existe){
    stdout.writeln("Contraseña guardada correctamente");
    return "menuAcciones";
  }else{
    stdout.writeln("La contraseña o el usuario ya existen. Intentelo de nuevo");
    return "menuAcciones";
  }
  }
}
