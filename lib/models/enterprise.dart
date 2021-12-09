class Enterprise {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  bool isMarked;

  Enterprise({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    this.isMarked = false,
  });
}
