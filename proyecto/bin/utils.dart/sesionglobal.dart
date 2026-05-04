import '../entities.dart/entities.dart'; // Asegúrate de importar tu clase Usuario

class SesionGlobal {
  static Usuario? usuarioActual;
  static void limpiarSesion() {
    usuarioActual = null;
  }
}