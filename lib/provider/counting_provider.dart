import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:celta_inventario/models/countings.dart';
import 'package:flutter/cupertino.dart';

class CountingProvider with ChangeNotifier {
  List<Countings> _countings = [];

  List<Countings> get countings {
    return [..._countings];
  }

  int get countingsQuantity {
    return countings.length;
  }

  String countingsErrorMessage = '';

  bool isChargingCountings = false;
  getCountings({
    int? inventoryProcessCode,
    String? userIdentity,
  }) async {
    _countings.clear();
    countingsErrorMessage = '';
    isChargingCountings = true;

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl().baseUrl}/Inventory/GetCountings?inventoryProcessCode=3'));
      request.body = json.encode(
        userIdentity,
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseInString = await response.stream.bytesToString();
      final List responseInList = json.decode(responseInString);
      final Map responseInMap = responseInList.asMap();

      responseInMap.forEach((id, data) {
        _countings.add(
          Countings(
            codigoInternoInvCont: data['CodigoInterno_InvCont'],
            flagTipoContagemInvCont: data['FlagTipoContagem_InvCont'],
            codigoInternoInventario: data['CodigoInterno_Inventario'],
            numeroContagemInvCont: data['NumeroContagem_InvCont'],
            obsInvCont: data['Obs_InvCont'],
          ),
        );
      });
    } catch (e) {
      countingsErrorMessage = 'Servidor não encontrado';
    } finally {
      isChargingCountings = false;
    }

    notifyListeners();
  }
}
