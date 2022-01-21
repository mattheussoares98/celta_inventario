import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityProvider with ChangeNotifier {
  bool isLoadingEntryQuantity = false;

  String entryQuantityError = '';

  bool isConfirmed = false;

  Future<void> entryQuantity({
    int? countingCode,
    int? productPackingCode,
    int? quantity,
    String? userIdentity,
    String? baseUrl,
  }) async {
    isLoadingEntryQuantity = true;
    entryQuantityError = '';

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
        isConfirmed = true;
      } else {}
    } catch (e) {
      entryQuantityError =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
    } finally {
      isLoadingEntryQuantity = false;
    }
    notifyListeners();
  }
}
