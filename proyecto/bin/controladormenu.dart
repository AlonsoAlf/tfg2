import 'dart:io';
import 'entities.dart/usuario.dart';
abstract class Controladormenu {
static Usuario? usuario;
static Map<String,String> registro(){
  Map<String, String> datos;
  String? nombre;
  String? apodo;
  String? password;
  do{
    stdout.writeln("Introduzca su nombre");
      nombre = stdin.readLineSync()?? "";
    stdout.writeln("Introduzca su apodo");
      apodo = stdin.readLineSync()?? "";
    stdout.writeln("Introduzca una contraseña (minimo 8 caracteres)");
      password = stdin.readLineSync()?? "";
    if(nombre.isEmpty || apodo.isEmpty || password.isEmpty){
      stdout.writeln("Ningun campo puede quedar vacio");
    }
    if( password.length < 8){
      stdout.writeln("La contraseña debe tener al menos 8 caracteres");
    }
  }while(nombre.isEmpty || apodo.isEmpty || password.isEmpty || password.length < 8);
  datos = {"nombre": nombre, "nick": apodo, "password": password};
  return datos;
}
static bool inicioSesion(Map<String,String>datos){
    String? apodo;
    String? password;
  do{
    stdout.writeln("Introduzca su apodo");
      apodo = stdin.readLineSync()?? "";
    stdout.writeln("Introduzca su contraseña");
      password = stdin.readLineSync()?? "";
    if(password.length<8){
      stdout.writeln("La contraseña debe tener minimo 8 caracteres");
      continue;
    }
    if(apodo.isEmpty || password.isEmpty){
      stdout.writeln("Ningun campo puede quedar vacio");
    }
  }while(apodo.isEmpty || password.length<8 || password.isNotEmpty);
  if(datos["apodo"] != apodo && datos["password"] != password){
    stdout.writeln("Contraseña o usuario erroneos, intentelo de nuevo");
    return false;
  }else{
    stdout.writeln("Bienvenido $apodo");
    return true;
  }
}

}