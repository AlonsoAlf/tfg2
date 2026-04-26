import 'package:mysql1/mysql1.dart';
import '../utils.dart/utils.dart';

class Cuenta {
  int? iduser;
  String? cuenta;
  String? passwordCuenta;
  Cuenta(this.cuenta, this.passwordCuenta, this.iduser);
  static Future<bool> existeCuenta(Map<String, String> data) async {
    MySqlConnection conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("SELECT * FROM cuentas WHERE cuenta = ?", [data["cuenta"]]);
    bool existe = respuesta.isNotEmpty;
    if (existe) {
      await conn.close();
      return false;
    }
    await conn.query("INSERT INTO cuentas (cuenta,passwordCuenta) VALUES(?,?)",[data["cuenta"], data["passwordCuenta"]]);
    await conn.close();
    return true;
  }

  Cuenta.fromDataBase(ResultRow row) {
    iduser = row["iduser"];
    cuenta = row["cuenta"];
    passwordCuenta = row["passwordcuenta"];
  }
  static Future<List<Cuenta>> devolverCuentas() async {
    var conn = await DataBase.establecerConexion(); //llamamos a la bbdd
    var registros = await conn.query("""SELECT * FROM cuentas""");
    List<Cuenta> listado = [];
    for (ResultRow registro in registros) {
      Cuenta cuenta = Cuenta.fromDataBase(registro);

      listado.add(cuenta);
    }
    return listado;
  }

  String toString() {
    return 'Cuenta(ID: $iduser, Nombre: $cuenta, Contraseña: $passwordCuenta)';
  }
}
