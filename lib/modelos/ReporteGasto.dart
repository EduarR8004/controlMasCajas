class ReporteGasto {
  String usuario;
  String nombre;
  String fecha;
  String valor;
  String tipo;
  String observaciones;
  ReporteGasto({
    this.usuario,
    this.fecha,
    this.valor,
    this.tipo,
    this.nombre,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre':nombre,
      'usuario': usuario,
      'fecha': fecha,
      'valor': valor,
      'tipo': tipo,
      'observaciones':observaciones,
    };
  }

  factory ReporteGasto.fromJson(Map<String, dynamic> json) {
    return ReporteGasto(
      nombre:json["nombre"]==null?json["nombre"]=0:json["nombre"],
      usuario: json['usuario']==null?json['usuario']=0:json['usuario'],
      fecha: json['fecha']==null?json['fecha']=0:json['fecha'],
      valor: json['valor']==null?json['valor']=0:json['valor'],
      tipo: json['tipo']==null?json['tipo']=0:json['tipo'],
      observaciones:json['observaciones']==null?json['observaciones']=0:json['observaciones'],
    );
  }

}
