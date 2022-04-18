class Clave {
  
  String clave;
  String _tableName='Claves';

  Clave ({
    this.clave,
  });

  Map<String, dynamic>toMap() {
    return {
      "clave": clave,
    };
  }

  factory Clave.fromMap(Map<String ,dynamic>json)=> new Clave(
    clave:json["clave"],
  );

  String getTableName(){
     return this._tableName;
  }
}