import 'utils.dart';
import 'package:mysql1/mysql1.dart';
class Encriptacion {
String? passwordEncriptar;
Future<void> recuperarDatos() async{
MySqlConnection conn = await DataBase.establecerConexion();
var datos = await conn.query("SELECT * FROM cuentas");
  
  for (var row in datos) {
    print('Nombre: ${row[0]}');
  }
  await conn.close();
}

}