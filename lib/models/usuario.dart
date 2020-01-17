class Usuario {
  Map<dynamic, dynamic> profile_info = {
    'nombres': '',
    'apellidos': '',
    'cedula': '',
    'edad': '',
    'rol': '',
    'ocupacion':'',
  };

  Map<dynamic, dynamic> ubicacion = {
    'ciudad':'',
    'departamento':'',
    'direccion':'',    
  };

  void setUsuario(Map<dynamic, dynamic> newProfileInfo,Map<dynamic, dynamic> newUbicacion) {
    profile_info = newProfileInfo;
    ubicacion=newUbicacion;
  }


}
