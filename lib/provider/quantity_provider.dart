import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityProvider with ChangeNotifier {
  bool isLoadingQuantity = false;

  String quantityError = '';

  bool isConfirmedQuantity = false;

  //criado somente pra conseguir identificar quando foi chamado o método de subtração
  //e atualizar corretamente a mensagem da última quantidade digitada
  bool subtractedQuantity = false;

  bool canChangeTheFocus = false;

  String lastQuantityAdded = '';

  Future<void> entryQuantity({
    required int? countingCode,
    required int? productPackingCode,
    required String? quantity,
    required String? userIdentity,
    required String? baseUrl,
    required bool? isSubtract,
  }) async {
    if (isSubtract!) {
      subtractedQuantity = true;
    } else {
      subtractedQuantity = false;
    }
    isConfirmedQuantity = false;
    isLoadingQuantity = true;
    quantityError = '';
    canChangeTheFocus = false;
    notifyListeners();

    try {
      quantity = quantity!.replaceAll(RegExp(r','), '.');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          isSubtract
              ? '$baseUrl/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=-$quantity'
              : '$baseUrl/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=$quantity',
        ),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print('response do quantityProvider: $resultAsString');

      if (resultAsString.contains('não permite fracionamento')) {
        quantityError = 'Esse produto não permite fracionamento!';
      } else if (resultAsString.contains('request is invalid')) {
        quantityError = 'Operação inválida';
      } else if (resultAsString
          .contains('tornará a quantidade contada do produto negativa')) {
        quantityError =
            'A quantidade contada não pode ser negativa! Essa operação tornaria a quantidade negativa';
      }

      if (response.statusCode == 200) {
        print('deu certo o quantity provider');
        isConfirmedQuantity = true;
        lastQuantityAdded = quantity;
      } else {
        print('erro no quantityProvider');
      }
    } catch (e) {
      quantityError =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
    } finally {
      isLoadingQuantity = false;
    }
    canChangeTheFocus = true;
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
