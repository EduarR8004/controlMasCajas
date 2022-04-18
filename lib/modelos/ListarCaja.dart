class ListarCaja {

  double ingreso;
  String fecha;
  String usuario;
  double retiro;
  double baseRuta;
  double ingresoRuta;
  String usuarioRuta;
  String administrador;
  String ruta;
  ListarCaja({
    this.ingreso,
    this.fecha,
    this.usuario,
    this.retiro,
    this.baseRuta,
    this.ingresoRuta,
    this.usuarioRuta,
    this.administrador,
    this.ruta,
  });


  Map<String, dynamic> toMap() {
    return {
      'ingreso': ingreso,
      'fecha': fecha,
      'usuario': usuario,
      'retiro': retiro,
      'baseRuta': baseRuta,
      'ingresoRuta': ingresoRuta,
      'usuarioRuta': usuarioRuta,
      'administrador': administrador,
      'ruta': ruta,
    };
  }

  factory ListarCaja.fromJson(Map<String, dynamic> json) => new ListarCaja(
    ingreso:json['ingreso']==null?json['ingreso']=0.0:double.parse(json['ingreso']),
    fecha: json['fecha']==null?json['fecha']='':json['fecha'],
    usuario: json['usuario']==null?json['usuario']='':json['usuario'],
    retiro: json['retiro']==null?json['retiro']=0.0:double.parse(json['retiro']),
    baseRuta: json['base_ruta']==null?json['base_ruta']=0.0:double.parse(json['base_ruta']),
    ingresoRuta:json['ingreso_ruta']==null?json['ingreso_ruta']=0.0:double.parse(json['ingreso_ruta']),
    usuarioRuta: json['usuario_ruta']==null?json['usuario_ruta']='No aplica':json['usuario_ruta'],
    administrador: json['administrador'],
    ruta: json['ruta']==null?json['ruta']='No aplica':json['ruta'],
  );
  
}
