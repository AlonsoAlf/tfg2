import 'dart:io';
import '../entities.dart/entities.dart';
import 'utils.dart';
abstract class Controladormenu {
  static Usuario? usuario;
  static String inicio = "pantallaPrincipal";
  static String pantallaPrincipal() {
    String? opcion;
    int? numero;
    do {
      stdout.writeln("Bienvenido, seleccione una acción:");
      stdout.writeln("1. Iniciar sesion");
      stdout.writeln("2. Registrarse");
      stdout.writeln("3. Salir");
      opcion = stdin.readLineSync() ?? "";
      numero = int.tryParse(opcion);
      if (numero == null) {
        stdout.writeln("Valor invalido. Por favor, intentelo de nuevo");
        continue;
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3");
    if (opcion == "1") {
      return "pantallaInicioSesion";
    } else if (opcion == "2") {
      return "pantallaRegistro";
    } else {
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
      } else if (password.length < 8) {
        stdout.writeln("La contraseña debe tener al menos 8 caracteres");
      }
    } while (nombre.isEmpty ||
        apodo.isEmpty ||
        password.isEmpty ||
        password.length < 8);
    datos = {"nombre": nombre, "apodo": apodo, "password": password};
    bool registrado = await Usuario.registro(datos);
    if (registrado) {
      stdout.writeln("Usuario registrado correctamente");
      return "pantallaPrincipal";
    } else {
      stdout.writeln("El usuario ya, existe vuelve a intentarlo");
      return "pantallaPrincipal";
    }
  }

  static Future<String> pantallaInicioSesion() async {
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
    bool logeado = await Usuario.inicioSesion(apodo, password);
    if (logeado) {
      stdout.writeln("Bienvenido $apodo");
      return "menuAcciones";
    } else {
      stdout.writeln("Usuario o contraseña incorrectos, vuelva intentarlo.");
      return "pantallaInicioSesion";
    }
  }

  static String menuAcciones() {
    String? opcion;
    do {
      stdout.writeln("Seleccione que acción desea hacer:");
      stdout.writeln("1. Añadir usuario y contraseña.");
      stdout.writeln("2. Gestionar contraseñas");
      stdout.writeln("3. Comprobar seguridad contraseña");
      stdout.writeln("4. Salir");
      opcion = stdin.readLineSync() ?? "";
      if (opcion.isEmpty) {
        stdout.writeln("Seleccione una opcion valida");
        continue;
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3" && opcion != "4");
    switch (opcion) {
      case "1":
        return "addCuenta";
      case "2":
        return "gestionar";
      case "3":
        return "comprobar";
      default:
        return "salir";
    }
  }

  static Future<String> addCuenta() async {
    Map<String, String> data;
    String? cuenta;
    String? passwordCuenta;
    do {
      stdout.writeln("Introduca el usuario o correo electronico asociado a la cuenta");
      cuenta = stdin.readLineSync() ?? "";
      stdout.writeln("Introduzca la contraseña de la cuenta");
      passwordCuenta = stdin.readLineSync() ?? "";
      if (cuenta.isEmpty || passwordCuenta.isEmpty) {
        stdout.writeln("Ningún campo puede quedar vacio, intentelo de nuevo");
      }
    } while (cuenta.isEmpty || passwordCuenta.isEmpty);
    data = {"cuenta": cuenta, "passwordCuenta": passwordCuenta};
    bool existe = await Cuenta.existeCuenta(data);
    if (existe) {
      stdout.writeln("Contraseña guardada correctamente");
      return "menuAcciones";
    } else {
      stdout.writeln("La contraseña o el usuario ya existen. Intentelo de nuevo");
      return "menuAcciones";
    }
  }
  static Future<String> opcionesGestionCuenta() async{
    String? opcion;
    int? numero;
    List<Cuenta> cuentas = await Cuenta.recuperarCuentas();
    for(int i = 0; i < cuentas.length; i++){
      stdout.writeln("${cuentas[i].iduser} [${cuentas[i].cuenta},${cuentas[i].passwordCuenta}]"); 
    }
    do{
      stdout.writeln("Seleccione como desea gestionar sus cuentas");
      stdout.writeln("1. Borrar cuenta");
      stdout.writeln("2. Modificar cuenta");
      stdout.writeln("3. Volver");
      opcion = stdin.readLineSync() ?? "";
      numero = int.tryParse(opcion);
      if (numero == null) {
        stdout.writeln("Valor invalido. Por favor, intentelo de nuevo");
        continue;
      }
    }while(opcion != "1" && opcion != "2" && opcion != "3");
    if (opcion == "1") {
      return "borrarCuenta";
    } else if (opcion == "2") {
      return "modificarCuenta";
    } else {
      return "menuAcciones";
    }
  }
  static Future<String> borrarCuenta() async{  
    try{
      stdout.writeln("Introduzca el ID de la cuenta que desa borrar");
      String respuesta = stdin.readLineSync() ?? "";
      int? iduser = int.tryParse(respuesta);
      var conn = await DataBase.establecerConexion();
      var borrado = await conn.query("DELETE FROM cuentas WHERE iduser = ?",[iduser]);
      int? affectedRows = borrado.affectedRows;
      if(affectedRows != null && affectedRows > 0){
        print("Cuenta eliminada correctamente");
        return "menuAcciones";
      }else if(affectedRows == 0){
        print("No se encontró ninguna cuenta con el ID $iduser");
        return "opcionesGestionCuenta";
      }else{
        print("Error, la base de datos no devolvió una respuesta valida");
        return "opcionesGestionCuenta";
      }
    }catch(error){
      return "menuAcciones";
    }
  }
  static Future<String> comprobarPassword() async{
    String? password;
    int? filtraciones;
    do {
      stdout.writeln("Introduzca la contraseña que desea comprobar",);
      password = stdin.readLineSync() ?? "";
      if (password.isEmpty) {
        stdout.writeln("Ningún campo puede quedar vacio, intentelo de nuevo");
      }
    } while (password.isEmpty);
    filtraciones = await Encriptacion.consultarPassword(password);
    if (filtraciones > 0) {
      print("La contraseña $password se ha filtrado $filtraciones veces, cambiala inmediatamente");
      return "opcionesGestionCuenta";
    } else {
      print("No se han encontrado filtraciones de $password");
      return "opcionesGestionCuenta";
    }
  }
}
