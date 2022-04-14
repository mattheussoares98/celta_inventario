class ProductInventoryModel {
  final String productName;
  final int codigoInternoProEmb;
  final String plu;
  final String codigoProEmb;
  dynamic quantidadeInvContProEmb;

  ProductInventoryModel({
    required this.productName,
    required this.codigoInternoProEmb,
    required this.plu,
    required this.codigoProEmb,
    required this.quantidadeInvContProEmb,
  });
}
