class Ventas {
  String idCliente;
  String idVenta;
  String alias;
  String nombre;
  String primerApellido;
  String segundoApellido; 
  String direccion;
  String ciudad;
  String departamento;
  String telefono;
  String usuario;
  String actividadEconomica;
  String documento;
  String motivo;
  double venta;
  double cuotas;
  double solicitado;
  double valorTemporal;
  int fecha;
  int fechaPago;
  String interes;
  double numeroCuota;
  double valorCuota;
  double saldo;
  String frecuencia;
  String ruta;
  String diaRecoleccion;
  String _tableName='Ventas';

  Ventas({
    this.idCliente,
    this.idVenta,
    this.alias,
    this.nombre,
    this.primerApellido,
    this.direccion,
    this.ciudad,
    this.departamento,
    this.telefono,
    this.usuario,
    this.actividadEconomica,
    this.documento,
    this.venta,
    this.solicitado,
    this.cuotas,
    this.valorTemporal,
    this.fecha,
    this.interes,
    this.fechaPago,
    this.numeroCuota,
    this.valorCuota,
    this.saldo,
    this.frecuencia,
    this.motivo,
    this.segundoApellido,
    this.ruta,
    this.diaRecoleccion,
  });

  Map<String, dynamic>toMap() {
    return {
    "idCliente":idCliente,
    "idVenta":idVenta,
    "alias":alias,
    "nombre":nombre,
    "primerApellido":primerApellido,
    "direccion":direccion,
    "ciudad":ciudad,
    "departamento":departamento,
    "telefono":telefono,
    "usuario":usuario,
    "actividadEconomica":actividadEconomica,
    "fechaPago":fechaPago,
    "documento":documento,
    "venta":venta,
    "solicitado":solicitado,
    "cuotas":cuotas,
    "valorTemporal":valorTemporal,
    "fecha":fecha,
    "interes":interes,
    "numeroCuota":numeroCuota,
    "valorCuota":valorCuota,
    "saldo":saldo,
    "frecuencia":frecuencia,
    "motivo":motivo,
    "segundoApellido":segundoApellido,
    "ruta":ruta,
    "diaRecoleccion":diaRecoleccion,
    };
  }

  factory Ventas.fromMap(Map<String ,dynamic>json)=> new Ventas(
    idVenta:json["idVenta"],
    idCliente:json["idCliente"],
    documento:json["documento"],
    venta:json["venta"],
    solicitado:json["solicitado"],
    cuotas:json["cuotas"],
    fecha:json["fecha"],
    fechaPago:json["fechaPago"],
    interes:json["interes"],
    numeroCuota:json["numeroCuota"],
    valorCuota:json["valorCuota"],
    valorTemporal:json["valorTemporal"],
    usuario:json["usuario"],
    saldo:json["saldo"],
    alias:json["alias"],
    nombre:json["nombre"],
    primerApellido:json["primerApellido"],
    direccion:json["direccion"],
    ciudad:json["ciudad"],
    departamento:json["departamento"],
    telefono:json["telefono"],
    actividadEconomica:json["actividadEconomica"],
    frecuencia:json["frecuencia"],
    motivo:json["motivo"],
    segundoApellido:json["segundoApellido"],
    ruta:json["ruta"],
    diaRecoleccion:json["diaRecoleccion"],
  );

  String getTableName(){
     return this._tableName;
  }
}