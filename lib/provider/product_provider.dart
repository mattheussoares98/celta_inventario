import 'package:celta_inventario/models/product.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  bool isChargingEan = false;

  int? codigoInternoEmpresa;
  int? codigoInternoInventario;

  String productErrorMessage = '';

  Future<void> getProductByEan(
    String ean,
    int enterpriseCode,
    int inventoryProcessCode,
    int inventoryCountingCode,
  ) async {
    _products.clear();
    productErrorMessage = '';
    isChargingEan = true;

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.baseUrl}/Inventory/GetProductByEan?ean=$ean&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
      request.body = json.encode(
          "¬EncryptedDataInfo£¬EncryptedData£LWtZl6CLFCTOVzlELFgTpCFSmnVszQEwvSaI8ILAqsQRjfqsUA9b2vt8/D0KqYaGfCMSVG5hJU5y200WXB64qGNzLcwuY3k2CHdRXZSnZqNMKzNu4M/gQ2FnibOScf7eqbDjLgkBUNYt9YXK/d9GvlSH2cuAFLGx0uighYRMy6FET9gbyqaPA5gZUaiySrhIhiqHHp/14qBRdQtzYqW1/XNuo4oG1RXSvXJWMeQ+AF07hAnRXUwLlH5nzRLR4LeAvJvMm1oh7lAI6ieHXnDaS2FLD1hyFsTiAaZ/Zecrefk0bWd96tjlck+5P9FR7rKo4ZElGLJwVeRCMsD9v13TeK6nYcuZOnQo+5cEHJhS7GaN0TPJ3qG3bigB6jEWhwDizH8Y4MDIcmcpDV60Q4zIT/+0BpbeCZio¬/EncryptedData£¬EncryptedIV£FE4MfmTvhvPuT2TOrw1gKSkvQCZ9EUxrIbIWDT6mFBtH1DgQ3+pLyMhtnW/1EqPQK2dtrOu9rbPrjY74XwAS8Il6Jej8+/zJZ24mv9fTxj/HgLAFtEbBmiBs9CuGXQYw8XC+g+faq3/+4XrsXSnP9VuC7Rv9IRU5jdPByd3VAeA=¬/EncryptedIV£¬EncryptedKey£sprQMTpv65da9DDoIRVS0hxa/+G91vmsMgkHrvd9fGgqebW8qs0wRF6jzXpwX2MaQzpi/bfrac2XqLOMDpS0gMPdUMBkwI+UCTbiMnJlulCWTxtlZYKojb6DcK2Wtf0BS8hWBp/z+UYWTEWiCq0ctYSwwpHzQ0wK7bGGGjdXi9U=¬/EncryptedKey£¬/EncryptedDataInfo£");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print(responseInString);

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
      print('erro do productByEAN');
      print(e.toString());
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } finally {}
    notifyListeners();
  }

  getProductByPlu(
    String plu,
    int enterpriseCode,
    int inventoryProcessCode,
    int inventoryCountingCode,
  ) async {
    _products.clear();
    productErrorMessage = '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '${BaseUrl.baseUrl}/Inventory/GetProductByPlu?plu=$plu&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode',
        ),
      );
      request.body = json.encode(
          "¬EncryptedDataInfo£¬EncryptedData£LWtZl6CLFCTOVzlELFgTpCFSmnVszQEwvSaI8ILAqsQRjfqsUA9b2vt8/D0KqYaGfCMSVG5hJU5y200WXB64qGNzLcwuY3k2CHdRXZSnZqNMKzNu4M/gQ2FnibOScf7eqbDjLgkBUNYt9YXK/d9GvlSH2cuAFLGx0uighYRMy6FET9gbyqaPA5gZUaiySrhIhiqHHp/14qBRdQtzYqW1/XNuo4oG1RXSvXJWMeQ+AF07hAnRXUwLlH5nzRLR4LeAvJvMm1oh7lAI6ieHXnDaS2FLD1hyFsTiAaZ/Zecrefk0bWd96tjlck+5P9FR7rKo4ZElGLJwVeRCMsD9v13TeK6nYcuZOnQo+5cEHJhS7GaN0TPJ3qG3bigB6jEWhwDizH8Y4MDIcmcpDV60Q4zIT/+0BpbeCZio¬/EncryptedData£¬EncryptedIV£FE4MfmTvhvPuT2TOrw1gKSkvQCZ9EUxrIbIWDT6mFBtH1DgQ3+pLyMhtnW/1EqPQK2dtrOu9rbPrjY74XwAS8Il6Jej8+/zJZ24mv9fTxj/HgLAFtEbBmiBs9CuGXQYw8XC+g+faq3/+4XrsXSnP9VuC7Rv9IRU5jdPByd3VAeA=¬/EncryptedIV£¬EncryptedKey£sprQMTpv65da9DDoIRVS0hxa/+G91vmsMgkHrvd9fGgqebW8qs0wRF6jzXpwX2MaQzpi/bfrac2XqLOMDpS0gMPdUMBkwI+UCTbiMnJlulCWTxtlZYKojb6DcK2Wtf0BS8hWBp/z+UYWTEWiCq0ctYSwwpHzQ0wK7bGGGjdXi9U=¬/EncryptedKey£¬/EncryptedDataInfo£");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();
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
      print('responseInMap $responseInMap');
    } catch (e) {
      print('erro do productByPLU');
      print(e.toString());
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } finally {}
    notifyListeners();
  }
}
