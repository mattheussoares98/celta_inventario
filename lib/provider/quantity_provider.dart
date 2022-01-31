import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityProvider with ChangeNotifier {
  bool isLoadingQuantity = false;

  String quantityError = '';

  bool isConfirmedQuantity = false;

  Future<void> entryQuantity({
    int? countingCode,
    int? productPackingCode,
    int? quantity,
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
        print(await response.stream.bytesToString());
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
