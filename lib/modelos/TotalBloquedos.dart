
class TotalBloqueados {
  double venta;
  double solicitado;
  double saldo;
  TotalBloqueados({
    this.venta,
    this.solicitado,
    this.saldo,
  });


  Map<String, dynamic> toMap() {
    return {
      'venta': venta,
      'solicitado': solicitado,
      'saldo': saldo,
    };
  }

  factory TotalBloqueados.fromMap(Map<String, dynamic> json) {
    return TotalBloqueados(
      venta: double.parse(json['venta'])==null?0.0:double.parse(json['venta']),
      solicitado: double.parse(json['solicitado'])==null?0.0:double.parse(json['solicitado']),
      saldo: double.parse(json['saldo'])==null?0.0:double.parse(json['saldo']),
    );
  }

}
