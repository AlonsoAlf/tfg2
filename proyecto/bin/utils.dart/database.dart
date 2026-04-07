import 'package:mysql1/mysql1.dart';
abstract class DataBase {
  static final String _host = "localhost";
  static final int _port = 3306;
  static final String _user = "root";
  static final String _dbName = "basedatosproyecto_db";

  static Future<void> instalacion() async{
    var settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      db: _dbName
    );
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query("CREATE DATABASE IF NOT EXISTS basedatosproyecto_db");
    await conn.query("USE $_dbName");
    await crearTablaUsers(conn);
    await crearTablaCuentas(conn);
    await conn.close();//importante cerrar conexion
  }
  static Future<MySqlConnection> establecerConexion() async{
    var settings = ConnectionSettings(      
      host: _host,
      port: _port,
      user: _user,
      db: _dbName
      );
      MySqlConnection conn = await MySqlConnection.connect(settings);
      return conn;
  }
  static Future<void> crearTablaUsers(MySqlConnection conn) async{
    await conn.query("""CREATE TABLE IF NOT EXISTS users(
        iduser INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR(100) NOT NULL,
        apodo VARCHAR(100) NOT NULL,
        password VARCHAR(100) NOT NULL
    );
    """);
  }
  static Future<void> crearTablaCuentas(MySqlConnection conn) async{
    await conn.query("""CREATE TABLE IF NOT EXISTS cuentas(
        iduser INT PRIMARY KEY AUTO_INCREMENT,
        cuenta VARCHAR(100) NOT NULL,
        passwordcuenta VARCHAR(100) NOT NULL
    );
  """);
  }
}