class Vehiculo {
  Map<dynamic, dynamic> vehiculo_info = {
    'placa': '',
    'tipo': '',
    'cc_propietario': '',
    'marca': '',
    'modelo': '',
    'color': '',
    'soat': '',
    'poliza': '',
  };

  Vehiculo(Map<dynamic, dynamic> newVehiculoInfo) {
    vehiculo_info = newVehiculoInfo;
  }
}
