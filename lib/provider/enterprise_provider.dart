import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:celta_inventario/models/enterprise.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EnterpriseProvider with ChangeNotifier {
  List<Enterprise> _enterprises = [];

  List<Enterprise> get enterprises {
    return [..._enterprises];
  }

  int get enterpriseCount {
    return _enterprises.length;
  }

  String enterpriseErrorMessage = '';

  bool isChargingEnterprises = false;

  clearEnterprises() {
    _enterprises.clear();
  }

  Future getEnterprises({
    String? userIdentity,
    String? baseUrl,
  }) async {
    enterpriseErrorMessage = '';
    isChargingEnterprises = true;
    notifyListeners();

    if (_enterprises.isNotEmpty) {
      _enterprises.clear();
    }

    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$baseUrl/Enterprise/GetEnterprises'));
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      List resultAsList = json.decode(resultAsString);
      Map resultAsMap = resultAsList.asMap();

      resultAsMap.forEach((id, data) {
        _enterprises.add(
          Enterprise(
            codigoInternoEmpresa: data['CodigoInterno_Empresa'],
            codigoEmpresa: data['Codigo_Empresa'],
            nomeEmpresa: data['Nome_Empresa'],
            isMarked: false,
          ),
        );
      });
    } catch (e) {
      print('erro na empresa: $e');
      if (e.toString().contains('No route')) {
        enterpriseErrorMessage =
            'O servidor não foi encontrado. Verifique a sua internet!';
      } else if (e.toString().contains('Connection timed')) {
        enterpriseErrorMessage = 'Time out. Tente novamente';
      } else {
        enterpriseErrorMessage =
            'O servidor não foi encontrado. Verifique a sua internet!';
      }
    } finally {
      isChargingEnterprises = false;
    }

    notifyListeners();
  }
}
