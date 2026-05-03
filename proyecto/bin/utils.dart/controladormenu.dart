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
      stdout.writeln("""
==============================================
        Bienvenido, seleccione una opcion:
==============================================
        1. Iniciar sesion    
        2. Registrarse
        3. Salir
==============================================
      """);         
      opcion = stdin.readLineSync() ?? "";
      numero = int.tryParse(opcion);
      if (numero == null) {
        stdout.writeln("""
        Valor invalido. Por favor, intentelo de nuevo
        """);
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
      stdout.writeln("""
        Introduzca su nombre
      """);
      nombre = stdin.readLineSync() ?? "";
      stdout.writeln("""
        Introduzca su apodo
        """);
      apodo = stdin.readLineSync() ?? "";
      stdout.writeln("""
        Introduzca una contraseña (minimo 8 caracteres)
        """);
      password = stdin.readLineSync() ?? "";
      if (nombre.isEmpty || apodo.isEmpty || password.isEmpty) {
        stdout.writeln("""
        Ningun campo puede quedar vacio
        """);
      } else if (password.length < 8) {
        stdout.writeln("""
        La contraseña debe tener al menos 8 caracteres
        """);
      }
    } while (nombre.isEmpty ||
        apodo.isEmpty ||
        password.isEmpty ||
        password.length < 8);
    datos = {"nombre": nombre, "apodo": apodo, "password": password};
    bool registrado = await Usuario.registro(datos);
    if (registrado) {
      stdout.writeln("""
        Usuario registrado correctamente
        """);
      return "pantallaPrincipal";
    } else {
      stdout.writeln("""
        El usuario ya, existe vuelve a intentarlo
        """);
      return "pantallaPrincipal";
    }
  }

  static Future<String> pantallaInicioSesion() async {
    String? apodo;
    String? password;
    do {
      stdout.writeln("""
        Introduzca su apodo
      """);
      apodo = stdin.readLineSync() ?? "";
      stdout.writeln("""
        Introduzca su contraseña
        """);
      password = stdin.readLineSync() ?? "";
      if (password.length < 8) {
        stdout.writeln("""
        La contraseña debe tener al menos 8 caracteres
        """);
        continue;
      }
      if (apodo.isEmpty || password.isEmpty) {
        stdout.writeln("""
        Ningun campo puede quedar vacio
        """);
        continue;
      }
    } while (apodo.isEmpty || password.isEmpty);
    bool logeado = await Usuario.inicioSesion(apodo, password);
    if (logeado) {
      stdout.writeln("""
==============================================
        Bienvenido $apodo""");
      return "menuAcciones";
    } else {
      stdout.writeln("""
        Usuario o contraseña incorrectos, vuelva intentarlo.
        """);
      return "pantallaInicioSesion";
    }
  }

  static String menuAcciones() {
    String? opcion;
    do {
      stdout.writeln("""
        Seleccione que acción desea hacer:
==============================================
        1. Añadir usuario y contraseña.
        2. Gestionar contraseñas.
        3. Buscar filtraciones de una contraseña.
        4. Salir.
==============================================
""");
      opcion = stdin.readLineSync() ?? "";
      if (opcion.isEmpty) {
        stdout.writeln("""
        Seleccione una opcion valida
        """);
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
      stdout.writeln("""
        Introduca el usuario o correo electronico asociado a la cuenta.
        """);
      cuenta = stdin.readLineSync() ?? "";
      stdout.writeln("""
        Introduzca la contraseña de la cuenta
        """);
      passwordCuenta = stdin.readLineSync() ?? "";
      if (cuenta.isEmpty || passwordCuenta.isEmpty) {
        stdout.writeln("""
        Ningún campo puede quedar vacio, intentelo de nuevo
        """);
      }
    } while (cuenta.isEmpty || passwordCuenta.isEmpty);
    data = {"cuenta": cuenta, "passwordCuenta": passwordCuenta};
    bool existe = await Cuenta.existeCuenta(data);
    if (existe) {
      stdout.writeln("""
        Contraseña guardada correctamente.
        """);
      return "menuAcciones";
    } else {
      stdout.writeln("""
        La contraseña o el usuario ya existen. Intentelo de nuevo.
        """);
      return "menuAcciones";
    }
  }

  static Future<String> opcionesGestionCuenta() async {//hay que refactorizar
    String? opcion;
    int? numero;
    List<Cuenta> cuentas = await Cuenta.recuperarCuentas();
    for (int i = 0; i < cuentas.length; i++) {
      stdout.writeln("""\n${cuentas[i].idcuenta}  [${cuentas[i].cuenta},  ${cuentas[i].passwordCuenta}]""");
    }
    do {
      stdout.writeln("""
=======================================================
        Seleccione como desea gestionar sus cuentas
=======================================================
        1. Borrar cuenta
        2. Modificar cuenta
        3. Volver
=======================================================
""");
      opcion = stdin.readLineSync() ?? "";
      numero = int.tryParse(opcion);
      if (numero == null) {
        stdout.writeln("""
        Valor invalido. Por favor, intentelo de nuevo.
        """);
        continue;
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3");
    if (opcion == "1") {
      return "borrarCuenta";
    } else if (opcion == "2") {
      return "modificarCuenta";
    } else {
      return "menuAcciones";
    }
  }
  static Future<String> cuentaBorrada()async{
    String? respuesta;
    int? idcuenta;
    try{
      stdout.writeln("""
        Introduzca el ID de la cuenta que desa borrar.
        """);
      respuesta = stdin.readLineSync()?? "";
      if(respuesta.isEmpty){
        stdout.writeln("""
        Debe introducir un ID valido, intentelo de nuevo.
        """);
      }else if(respuesta.isNotEmpty){
        idcuenta = int.tryParse(respuesta);
      }
      var resultado = await Cuenta.borrarCuenta(idcuenta!);
      if(resultado != null && resultado > 0){
        stdout.writeln("""
        Cuenta borrada correctamente.
        """);
        return "menuAcciones";  
      }else if (resultado == 0){
        stdout.writeln("""
        No se encontró ninguna cuenta con el ID $idcuenta
        """);
        return "opcionesGestionCuenta";
      }
      return "opcionesGestionCuenta";
    }catch(error){
      stdout.writeln("""
        Introduzca un ID formado por numeros enteros.
        """);
    }
    return "opcionesGestionCuenta";
  }

  static Future<String> cuentaModificada() async {
  String? respuesta;
  int? idcuenta;
  String? cuenta;
  String? passwordCuenta;
  try{
    stdout.writeln("""
        Introduzca el ID de la cuenta que desa modificar.
        """);
    respuesta = stdin.readLineSync() ?? "";
    stdout.writeln("""
        Introduzca el nuevo nombre de usuario.
        """);
    cuenta = stdin.readLineSync() ?? "";
    stdout.writeln("""
        Introduzca la nueva contraseña.
        """);
    passwordCuenta = stdin.readLineSync() ?? "";
    if (respuesta.isEmpty || cuenta.isEmpty || passwordCuenta.isEmpty) {
      stdout.writeln("""
        Ningún campo puede quedar vacio.
        """);
    }
    if (respuesta.isNotEmpty) {
      idcuenta = int.tryParse(respuesta);
    }
    var resultado = await Cuenta.modificarCuenta(idcuenta!,cuenta,passwordCuenta);
    if (resultado != null && resultado > 0) {
      stdout.writeln("""
        Cuenta modificada correctamente.
        """);
      return "menuAcciones";
    } else if (resultado == 0) {
      stdout.writeln("""
        No se encontró ninguna cuenta con el ID $idcuenta
        """);
      return "opcionesGestionCuenta";
    }
    return "opcionesGestionCuenta";
  }catch(error){
    stdout.writeln("""
        Introduzca un ID formado por numeros enteros.
        """);
  }
  return "opcionesGestionCuenta";
  }

  static Future<String> comprobarPassword() async {
  String? password;
  int? filtraciones;
  do {
    stdout.writeln("""
        Introduzca la contraseña que desea comprobar.
        """);
    password = stdin.readLineSync() ?? "";
    if (password.isEmpty) {
      stdout.writeln("""
        Ningún campo puede quedar vacio, intentelo de nuevo.
        """);
    }
  } while (password.isEmpty);
    filtraciones = await Encriptacion.consultarPassword(password);
  if (filtraciones > 0) {
    stdout.writeln("""
        La contraseña $password se ha filtrado $filtraciones veces, cambiala inmediatamente.
        """);
    return "menuAcciones";
  } else {
    stdout.writeln("""
        No se han encontrado filtraciones de $password
        """);
    return "menuAcciones";
  }
  }
}
