class CuadreSemana {
  String asignado;
  String salidas;
  String entradas;

  CuadreSemana({
    this.asignado,
    this.salidas,
    this.entradas,
  });


  factory CuadreSemana.fromJson(Map<String, dynamic> map) {
    return CuadreSemana(
      asignado: map['asignado'] ?? '',
      salidas: map['salidas'] ?? '',
      entradas: map['entradas'] ?? '',
    );
  }

}
