import 'package:celta_inventario/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  bool isLoadingEanOrPlu = false;

  int? codigoInternoEmpresa;
  int? codigoInternoInventario;

  String errorMessage = '';

  returnAndNotify() {
    isLoadingEanOrPlu = false;
    notifyListeners();
    return;
  }

  Future<void> getProductByEan({
    required String? ean,
    required int? enterpriseCode,
    required int? inventoryProcessCode,
    required int? inventoryCountingCode,
    required String? userIdentity,
    required String? baseUrl,
  }) async {
    _products.clear();
    errorMessage = '';
    isLoadingEanOrPlu = true;
    notifyListeners();
    print('provider consultando ean');
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

      print(responseInString);

      //tratando a mensagem de retorno aqui mesmo
      if (responseInString.contains('O produto não foi encontrado')) {
        errorMessage =
            'O produto não foi encontrado na contagem do processo de inventário.';
        returnAndNotify();
      } else if (responseInString.contains(
          "Ocorreu um erro durante a tentativa de atender um serviço de integração 'cross'")) {
        errorMessage =
            'Ocorreu um erro durante a tentativa de atender um serviço de integração "cross". Fale com seu administrador de sistemas, para resolver o problema.';
        returnAndNotify();
      } else if (responseInString
          .contains('"Message":"O EAN informado não é válido."')) {
        errorMessage = 'O EAN informado não é válido';
        returnAndNotify();
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
      errorMessage = 'Servidor não encontrado. Verifique a sua internet';
    }

    print('provider término consulta ean');
    isLoadingEanOrPlu = false;
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
    errorMessage = '';
    isLoadingEanOrPlu = true;
    notifyListeners();
    print('provider consultando plu');
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

      print('plu responseInString $responseInString');

      if (responseInString.contains('O produto não foi encontrado')) {
        errorMessage =
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
      errorMessage = 'Servidor não encontrado. Verifique a sua internet';
    }
    print('provider término consulta plu');
    isLoadingEanOrPlu = false;
    notifyListeners();
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }
}
