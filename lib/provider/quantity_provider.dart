import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityProvider with ChangeNotifier {
  bool isLoadingQuantity = false;

  String quantityError = '';

  bool isConfirmedQuantity = false;

  Future<void> addQuantity({
    int? countingCode,
    int? productPackingCode,
    String? quantity,
    String? userIdentity,
    String? baseUrl,
  }) async {
    isLoadingQuantity = true;
    quantityError = '';
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '$baseUrl/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=$quantity',
        ),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print('response do quantityProvider: $resultAsString');

      if (resultAsString.contains('não permite fracionamento')) {
        quantityError = 'Esse produto não permite fracionamento!';
      }

      if (response.statusCode == 200) {
        print('deu certo o quantity provider');
        isConfirmedQuantity = true;
      } else {
        print('erro no quantityProvider');
      }
    } catch (e) {
      quantityError =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
    } finally {
      isLoadingQuantity = false;
    }
    notifyListeners();
  }

  Future<void> subtractQuantity({
    int? countingCode,
    int? productPackingCode,
    String? quantity,
    String? userIdentity,
    String? baseUrl,
  }) async {
    isLoadingQuantity = true;
    quantityError = '';
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '$baseUrl/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=-$quantity',
        ),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print(resultAsString);

      if (resultAsString.contains(
          'A quantidade ajustada tornará a quantidade contada do produto negativa')) {
        quantityError = 'A quantidade não pode ser negativa!';
      }

      if (response.statusCode == 200) {
        isConfirmedQuantity = true;
      } else {}
    } catch (e) {
      quantityError =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
    } finally {
      isLoadingQuantity = false;
    }
    notifyListeners();
  }

  bool isConfirmedAnullQuantity = false;
  Future<void> anullQuantity({
    String? url,
    int? countingCode,
    int? productPackingCode,
    String? userIdentity,
  }) async {
    isConfirmedAnullQuantity = false;
    quantityError = '';
    isLoadingQuantity = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '$url/Inventory/AnnulQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode',
        ),
      );
      request.body = json.encode(userIdentity);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        isConfirmedAnullQuantity = true;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      quantityError =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
      print('Erro no anullQuantity: $e');
    } finally {}

    isLoadingQuantity = false;
    notifyListeners();
  }
}
