class Clave {
  
  String clave;
  String tipo;
  String usuario;
  String _tableName='Claves';

  Clave ({
    this.clave,
    this.tipo,
    this.usuario
  });

  Map<String, dynamic>toMap() {
    return {
      "clave": clave,
      "tipo": tipo,
      "usuario": usuario
    };
  }

  factory Clave.fromMap(Map<String ,dynamic>json)=> new Clave(
    clave:json["clave"],
    tipo:json["tipo"],
    usuario:json["usuario"],
  );

  String getTableName(){
     return this._tableName;
  }
}