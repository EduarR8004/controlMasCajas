class CuadreSemana {
  String asignado;
  String gasto;
  String entrega;
  String ventas;
  String retiro;
  String recolectado;
  String ultimaEntrega;

  CuadreSemana({
    this.asignado,
    this.retiro,
    this.entrega,
    this.ventas,
    this.gasto,
    this.recolectado,
    this.ultimaEntrega,
  });


  factory CuadreSemana.fromJson(Map<String, dynamic> map) {
    return CuadreSemana(
      gasto: map['gasto'] ?? '',
      retiro: map['retiro'] ?? '',
      ventas: map['ventas'] ?? '',
      entrega: map['entrega'] ?? '',
      asignado: map['asignado'] ?? '',
      recolectado: map['recolectado'] ?? '',
      ultimaEntrega: map['ultimaEntrega'] ?? '',
    );
  }

}

// SELECT SUM(a.asignado) as asignado,SUM(a.gasto) as gasto, SUM(a.entrega) AS entrega, SUM(a.ventas) as ventas,SUM(a.retiro) as retiro
//     FROM `produccion` as a 
//     WHERE a.fecha BETWEEN '2022-04-18' AND '2022-04-23' AND cerrado='NO' AND a.usuario='prueba1'
//     UNION
//     SELECT SUM(b.baseRuta),'','','' as base FROM base_ruta as b
//     WHERE b.fecha BETWEEN '2022-04-18' AND '2022-04-23' AND b.usuario='eramirez'