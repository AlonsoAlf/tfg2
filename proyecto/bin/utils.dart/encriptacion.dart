import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
class Encriptacion {
static Future<int> comprobarPassword(String password) async {
  // 1. Generar el Hash SHA-1
  String hash = sha1.convert(utf8.encode(password)).toString().toUpperCase();
  
  String prefix = hash.substring(0, 5);
  String suffix = hash.substring(5);
  // 2. Llamada a la API
  final url = Uri.parse('https://api.pwnedpasswords.com/range/$prefix');
  final response = await http.get(url, headers: {'User-Agent': 'Dart-App'});
  // 3. Procesar la respuesta si el servidor responde 200 (OK)
  if (response.statusCode == 200) {
    final List<String> lineas = const LineSplitter().convert(response.body);

    for (String linea in lineas) {
      final List<String> partes = linea.split(':');
      final String sufijoEncontrado = partes[0];
      final int coincidencias = int.parse(partes[1]);

      if (sufijoEncontrado == suffix) {
        return coincidencias; // Se encontró el sufijo, devolvemos las veces que aparece
      }
    }
  }
  return 0;
  }
}
