import 'package:celta_inventario/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  bool isChargingEanOrPlu = false;

  int? codigoInternoEmpresa;
  int? codigoInternoInventario;

  String productErrorMessage = '';

  Future<void> getProductByEan({
    String? ean,
    int? enterpriseCode,
    int? inventoryProcessCode,
    int? inventoryCountingCode,
    String? userIdentity,
    String? baseUrl,
  }) async {
    _products.clear();
    productErrorMessage = '';
    isChargingEanOrPlu = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '$baseUrl/Inventory/GetProductByEan?ean=$ean&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      //tratando a mensagem de retorno aqui mesmo
      if (responseInString.contains('O produto não foi encontrado')) {
        productErrorMessage =
            'O produto não foi encontrado na contagem do processo de inventário.';
        notifyListeners();
        return;
      } else if (responseInString.contains(
          "Ocorreu um erro durante a tentativa de atender um serviço de integração 'cross'")) {
        productErrorMessage =
            'Ocorreu um erro durante a tentativa de atender um serviço de integração "cross". Fale com seu administrador de sistemas, para resolver o problema.';
        notifyListeners();
        return;
      } else if (responseInString
          .contains('"Message":"O EAN informado não é válido."')) {
        notifyListeners();
        return;
      }

      List responseInList = json.decode(responseInString);
      Map responseInMap = responseInList.asMap();

      responseInMap.forEach((key, value) {
        _products.add(
          Product(
            productName: value['Nome_Produto'],
            codigoInternoProEmb: value['CodigoInterno_ProEmb'],
            plu: value['CodigoPlu_ProEmb'],
            codigoProEmb: value['Codigo_ProEmb'],
            quantidadeInvContProEmb: value['Quantidade_InvContProEmb'],
          ),
        );
      });
    } catch (e) {
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    }
    isChargingEanOrPlu = false;
    notifyListeners();
  }

  getProductByPlu({
    required String? plu,
    required int? enterpriseCode,
    required int? inventoryProcessCode,
    required int? inventoryCountingCode,
    required String? userIdentity,
    required String? baseUrl,
  }) async {
    _products.clear();
    productErrorMessage = '';
    isChargingEanOrPlu = true;
    notifyListeners();

    try {
      /// Antes estava usando essa forma comentada pra retornar os dados
      /// coloquei pra usar de outra forma pra ter as duas documentadas
      // var headers = {'Content-Type': 'application/json'};
      // var request = http.Request(
      //   'POST',
      //   Uri.parse(
      //     '$baseUrl/Inventory/GetProductByPlu?plu=$plu&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode',
      //   ),
      // );
      // request.body = json.encode(userIdentity);
      // request.headers.addAll(headers);
      // http.StreamedResponse response = await request.send();
      // String responseInString = await response.stream.bytesToString();

      http.Response response = await http.post(
        Uri.parse(
          '$baseUrl/Inventory/GetProductByPlu?plu=$plu&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userIdentity),
      );

      var responseInString = response.body;

      if (responseInString.contains('O produto não foi encontrado')) {
        productErrorMessage =
            'O produto não foi encontrado na contagem do processo de inventário.';
        notifyListeners();
        return;
      }

      List responseInList = json.decode(responseInString);
      Map responseInMap = responseInList.asMap();

      responseInMap.forEach((key, value) {
        _products.add(
          Product(
            productName: value['Nome_Produto'],
            codigoInternoProEmb: value['CodigoInterno_ProEmb'],
            plu: value['CodigoPlu_ProEmb'],
            codigoProEmb: value['Codigo_ProEmb'],
            quantidadeInvContProEmb: value['Quantidade_InvContProEmb'],
          ),
        );
      });
    } catch (e) {
      print('erro pra obter o produto pelo plu: $e');
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } finally {}
    isChargingEanOrPlu = false;
    notifyListeners();
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }
}
