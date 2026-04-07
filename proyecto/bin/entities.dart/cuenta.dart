import 'package:mysql1/mysql1.dart';
import '../utils.dart/utils.dart';
class Cuenta {
  String? cuenta;
  String? passwordCuenta;
  Cuenta(this.cuenta, this.passwordCuenta);
  static Future<bool> existePassword(Map<String,String>data) async{
    MySqlConnection conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("SELECT * FROM cuentas WHERE cuenta = ?", [data["cuenta"]]);
    bool existe = respuesta.isNotEmpty;
    if(existe){
      await conn.close();
      return false;
    }
    await conn.query("INSERT INTO cuentas (cuenta,passwordCuenta) VALUES(?,?)", [data["cuenta"], data["passwordCuenta"]]);
    await conn.close();
    return true;
  }
}
