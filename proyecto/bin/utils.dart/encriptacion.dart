import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
class Encriptacion {
static Future<int> consultarPassword(String password) async {
  final hash = sha1.convert(utf8.encode(password)).toString().toUpperCase();
  final prefix = hash.substring(0, 5);
  final suffix = hash.substring(5);
  var url = Uri.parse('https://api.pwnedpasswords.com/range/$prefix');
  var response = await http.get(url, headers: {'User-Agent': 'Proyecto-Dart'});

  if (response.statusCode == 200) {
    final List<String> lineas = const LineSplitter().convert(response.body);

    for (String linea in lineas) {
      final List<String> partes = linea.split(':');
      final String sufijoEncontrado = partes[0];
      final int coincidencias = int.parse(partes[1]);
      if (sufijoEncontrado == suffix) {
        return coincidencias;
      }
    }
  }else{
    print("error de la api");
  }
  return 0;
  }
}
