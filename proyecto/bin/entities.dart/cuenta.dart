import 'package:mysql1/mysql1.dart';
import '../utils.dart/utils.dart';

class Cuenta {
  int? idcuenta;
  String? cuenta;
  String? passwordCuenta;
  Cuenta(this.cuenta, this.passwordCuenta, this.idcuenta);
  static Future<bool> existeCuenta(Map<String, dynamic> data) async {
    MySqlConnection conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("SELECT * FROM cuentas WHERE cuenta = ?", [data["cuenta"]]);
    bool existe = respuesta.isNotEmpty;
    if (existe) {
      await conn.close();
      return false;
    }
    await conn.query("INSERT INTO cuentas (cuenta,passwordCuenta,iduser) VALUES(?,?,?)",[data["cuenta"], data["passwordCuenta"], data["iduser"]]);
    await conn.close();
    return true;
  }

  Cuenta.fromDataBase(ResultRow row) {
    idcuenta = row["idcuenta"];
    cuenta = row["cuenta"];
    passwordCuenta = row["passwordcuenta"];
  }
  static Future<List<Cuenta>> recuperarCuentas(int iduser) async {
    var conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("""SELECT * FROM cuentas WHERE iduser = ?""", [iduser] );
    List<Cuenta> listado = [];
    for (ResultRow registro in respuesta) {
      Cuenta cuenta = Cuenta.fromDataBase(registro);
      listado.add(cuenta);
    }
    return listado;
  }
  static Future<int?> borrarCuenta(int idcuenta) async{
    var conn = await DataBase.establecerConexion();
    var borrado = await conn.query("DELETE FROM cuentas WHERE idcuenta = ?",[idcuenta]);
    return borrado.affectedRows;
  }
  static Future<int?> modificarCuenta(int idcuenta, String cuenta, String passwordCuenta) async{
    var conn = await DataBase.establecerConexion();
    var modificado = await conn.query("UPDATE cuentas SET cuenta = ?, passwordCuenta = ? WHERE idcuenta = ?", [cuenta, passwordCuenta, idcuenta]);
    return modificado.affectedRows;
  }
}
