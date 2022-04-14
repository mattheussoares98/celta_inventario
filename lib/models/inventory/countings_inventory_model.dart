class CountingsInventoryModel {
  final int codigoInternoInvCont;
  final int numeroContagemInvCont;
  final int flagTipoContagemInvCont;
  final int codigoInternoInventario;
  final String obsInvCont;

  CountingsInventoryModel({
    required this.codigoInternoInvCont,
    required this.flagTipoContagemInvCont,
    required this.codigoInternoInventario,
    required this.numeroContagemInvCont,
    required this.obsInvCont,
  });
}
