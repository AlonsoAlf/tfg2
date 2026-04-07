import 'dart:io';
import '../entities.dart/entities.dart';

abstract class Controladormenu {
  static Usuario? usuario;
  static String inicio = "pantallaPrincipal";
  static Future<String> pantallaPrincipal() async{
    String? opcion;
  do {
    stdout.writeln("Bienvenido, seleccione una acción:");
    stdout.writeln("1. Iniciar sesion");
    stdout.writeln("2. Registrarse");
    stdout.writeln("3. Salir");
    opcion = stdin.readLineSync() ?? "";
    int.tryParse(opcion) ?? 0;
    int? numero = int.tryParse(opcion);
    if (numero == null) {
      stdout.writeln("Valor invalido. Por favor, intentelo de nuevo");
      continue;
    }
  } while (opcion != "1" && opcion != "2" && opcion != "3");//recuerda que == es "iguales" y != es "distintos"
  if(opcion == "1"){
    return "pantallaInicioSesion";
  }else if(opcion == "2"){
    return "pantallaRegistro";
  }else{
    return "salir";
  }
  }
  static Future<String> pantallaRegistro() async {
    Map<String, String> datos;
    String? nombre;
    String? apodo;
    String? password;
    do {
      stdout.writeln("Introduzca su nombre");
      nombre = stdin.readLineSync() ?? "";
      stdout.writeln("Introduzca su apodo");
      apodo = stdin.readLineSync() ?? "";
      stdout.writeln("Introduzca una contraseña (minimo 8 caracteres)");
      password = stdin.readLineSync() ?? "";
      if (nombre.isEmpty || apodo.isEmpty || password.isEmpty) {
        stdout.writeln("Ningun campo puede quedar vacio");
      } else if(password.length < 8){
        stdout.writeln("La contraseña debe tener al menos 8 caracteres");
      }
    } while (nombre.isEmpty || apodo.isEmpty || password.isEmpty || password.length < 8);
    datos = {"nombre": nombre, "apodo": apodo, "password": password};
    bool registrado = await Usuario.registro(datos);
    if(registrado){
      stdout.writeln("Usuario registrado correctamente");
      return "pantallaPrincipal";
    }else{
      stdout.writeln("El usuario ya, existe vuelve a intentarlo");
      return "pantallaPrincipal";
    }
  }

  static Future<String> pantallaInicioSesion(Map<String, String> datos) async {
    String? apodo;
    String? password;
    do {
      stdout.writeln("Introduzca su apodo");
      apodo = stdin.readLineSync() ?? "";
      stdout.writeln("Introduzca su contraseña");
      password = stdin.readLineSync() ?? "";
      if (password.length < 8) {
        stdout.writeln("La contraseña debe tener al menos 8 caracteres");
        continue;
      }
      if (apodo.isEmpty || password.isEmpty) {
        stdout.writeln("Ningun campo puede quedar vacio");
        continue;
      }
      } while (apodo.isEmpty || password.isEmpty);
      bool logeado = await Usuario.inicioSesion(apodo,password);
      if(logeado){
        stdout.writeln("Bienvenido $apodo");
        return "menuAcciones";
      }else{
        stdout.writeln("Usuario o contraseña incorrectos, vuelva intentarlo.");
        return "pantallaInicioSesion";
      }
  }
}
