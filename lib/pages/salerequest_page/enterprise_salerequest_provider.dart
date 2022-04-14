import 'dart:convert';

import 'package:celta_inventario/models/sale_request/enterprise_salerequest_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EnterpriseSaleRequestProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<EnterpriseSaleRequestModel> _enterprises = [];

  List get enterprises {
    return _enterprises;
  }

  getEnterprises() async {
    _enterprises.clear();
    _isLoading = true;
    // notifyListeners();

    try {
      var headers = {
        'user': 'Mattheus Soares',
        'accessKey': '0ItzNknbTm0kObI0d900vzQDvd3/F9WL',
        'Content-Type': 'application/json'
      };
      var request =
          http.Request('GET', Uri.parse('${BaseUrl.url}/API/enterprises'));
      request.body = '';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      // print(resultAsString);
      List resultAsList = json.decode(resultAsString);
      // print(resultAsList);
      Map resultAsMap = resultAsList.asMap();
      // print(resultAsMap[0]);

      resultAsMap.forEach((key, value) {
        _enterprises.add(
          EnterpriseSaleRequestModel(
            id: value['id'],
            cnpj: value['cnpj'],
            name: value['name'],
          ),
        );
      });
    } catch (e) {
      print('erro para consultar as empresas ===== $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
