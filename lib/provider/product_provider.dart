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
  bool isChargingPlu = false;

  int? codigoInternoEmpresa;
  int? codigoInternoInventario;

  String productErrorMessage = '';

  Future<void> getProductByEan(
    String ean,
    int enterpriseCode,
    int inventoryProcessCode,
    int inventoryCountingCode,
  ) async {
    productErrorMessage = '';
    isChargingEan = true;
    if (ean.length > 13) {
      productErrorMessage = 'EAN $ean inválido';
      isChargingEan = false;
      notifyListeners();
      return;
    }

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
      print('responseInStringEAN $responseInString');

      //tratando a mensagem de retorno aqui mesmo
      if (responseInString.contains('O produto não foi encontrado')) {
        productErrorMessage =
            'O EAN $ean não foi encontrado na contagem do processo de inventário.';
      } else if (responseInString.contains('O EAN informado não é válido')) {
        responseInString = 'O EAN $ean é inválido';
      } else if (responseInString.contains(
          "Ocorreu um erro durante a tentativa de atender um serviço de integração 'cross'")) {
        productErrorMessage =
            'Ocorreu um erro durante a tentativa de atender um serviço de integração "cross". Fale com seu administrador de sistemas, para resolver o problema.';
      }
    } catch (e) {
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } finally {
      isChargingEan = false;
    }
    notifyListeners();
  }

  getProductByPlu(
    String plu,
    int enterpriseCode,
    int inventoryProcessCode,
    int inventoryCountingCode,
  ) async {
    isChargingPlu = true;
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
            'O PLU $plu não foi encontrado na contagem do proceddo de inventário.';
      }
      print('responseInStringPLU $responseInString');
    } catch (e) {
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } finally {
      isChargingPlu = false;
    }
    notifyListeners();
  }
}
