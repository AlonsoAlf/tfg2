import 'package:mysql1/mysql1.dart';
import '../utils.dart/utils.dart';
class Usuario{
  int? iduser;
  String? nombre;
  String? apodo;
  String? password;
  Usuario(this.iduser,this.nombre,this.apodo,this.password);

  static Future<bool> registro(Map<String, String>datos) async {
    MySqlConnection conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("SELECT * FROM users WHERE apodo = ?", [datos["apodo"]]);
    bool existe = respuesta.isNotEmpty;
    if(existe){
      await conn.close();
      return false;
    }
    await conn.query("INSERT INTO users (nombre,apodo,password) VALUES(?,?,?)", [datos["nombre"], datos["apodo"], datos["password"]]);
    await conn.close();
    return true;
  }
  static Future<Usuario?> inicioSesion(String apodo, String password) async{
    MySqlConnection conn = await DataBase.establecerConexion();
    var respuesta = await conn.query("SELECT * FROM users WHERE apodo = ?", [apodo]);
    bool noExiste = respuesta.isEmpty;
    if(noExiste || respuesta.first[3] != password){
      await conn.close();
      return null;
    }
    Usuario usuarioLogueado = Usuario(
        respuesta.first[0],  
        respuesta.first[1],  
        respuesta.first[2],  
        respuesta.first[3]  
    );
    return usuarioLogueado;
  }
}
