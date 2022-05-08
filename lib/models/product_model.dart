class ProductModel {
  final String productName;
  final int codigoInternoProEmb;
  final String plu;
  final String codigoProEmb;
  dynamic quantidadeInvContProEmb;

  ProductModel({
    required this.productName,
    required this.codigoInternoProEmb,
    required this.plu,
    required this.codigoProEmb,
    required this.quantidadeInvContProEmb,
  });
}
