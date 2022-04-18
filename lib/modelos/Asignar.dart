class Asignar {
  String usuario;
  String fecha;
  double valor;
  String _tableName='Asignacion';
  Asignar({
    this.usuario,
    this.fecha,
    this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'fecha': fecha,
      'valor': valor,
    };
  }

  factory Asignar.fromMap(Map<String, dynamic> json) {
    return Asignar(
      usuario: json['usuario'],
      fecha: json['fecha'],
      valor: json['valor']==null?0.0:json['valor'],
    );
  }

  String getTableName(){
     return this._tableName;
  }
}
