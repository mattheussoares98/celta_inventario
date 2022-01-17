import 'package:celta_inventario/utils/base_url.dart';
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
  }) async {
    isLoadingEntryQuantity = true;
    entryQuantityError = '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '${BaseUrl().baseUrl}/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=$quantity',
        ),
      );
      request.body = json.encode(
          "¬EncryptedDataInfo£¬EncryptedData£LWtZl6CLFCTOVzlELFgTpCFSmnVszQEwvSaI8ILAqsQRjfqsUA9b2vt8/D0KqYaGfCMSVG5hJU5y200WXB64qGNzLcwuY3k2CHdRXZSnZqNMKzNu4M/gQ2FnibOScf7eqbDjLgkBUNYt9YXK/d9GvlSH2cuAFLGx0uighYRMy6FET9gbyqaPA5gZUaiySrhIhiqHHp/14qBRdQtzYqW1/XNuo4oG1RXSvXJWMeQ+AF07hAnRXUwLlH5nzRLR4LeAvJvMm1oh7lAI6ieHXnDaS2FLD1hyFsTiAaZ/Zecrefk0bWd96tjlck+5P9FR7rKo4ZElGLJwVeRCMsD9v13TeK6nYcuZOnQo+5cEHJhS7GaN0TPJ3qG3bigB6jEWhwDizH8Y4MDIcmcpDV60Q4zIT/+0BpbeCZio¬/EncryptedData£¬EncryptedIV£FE4MfmTvhvPuT2TOrw1gKSkvQCZ9EUxrIbIWDT6mFBtH1DgQ3+pLyMhtnW/1EqPQK2dtrOu9rbPrjY74XwAS8Il6Jej8+/zJZ24mv9fTxj/HgLAFtEbBmiBs9CuGXQYw8XC+g+faq3/+4XrsXSnP9VuC7Rv9IRU5jdPByd3VAeA=¬/EncryptedIV£¬EncryptedKey£sprQMTpv65da9DDoIRVS0hxa/+G91vmsMgkHrvd9fGgqebW8qs0wRF6jzXpwX2MaQzpi/bfrac2XqLOMDpS0gMPdUMBkwI+UCTbiMnJlulCWTxtlZYKojb6DcK2Wtf0BS8hWBp/z+UYWTEWiCq0ctYSwwpHzQ0wK7bGGGjdXi9U=¬/EncryptedKey£¬/EncryptedDataInfo£");
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
