class Siniestro {
  String ubicacion;
  String ciudad;
  String fecha;
  String dia;
  String descripcion;
  String condicionCarretera;
  String causaPrimaria;
  String factorAmbiental;
  String foto;
  String registradorUid;

  void setSiniestro({
    String ubicacion,
    String ciudad,
    String fecha,
    String dia,
    String descripcion,
    String condicionCarretera,
    String causaPrimaria,
    String factorAmbiental,
    String foto,
    String registradorUid,
  }) {
    this.ubicacion = ubicacion;
    this.ciudad = ciudad;
    this.fecha = fecha;
    this.dia = dia;
    this.descripcion = descripcion;
    this.condicionCarretera = condicionCarretera;
    this.causaPrimaria = causaPrimaria;
    this.factorAmbiental = factorAmbiental;
    this.foto = foto;
    this.registradorUid = registradorUid;
  }
}
