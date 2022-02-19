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
    String? baseUrl,
  }) async {
    _countings.clear();
    countingsErrorMessage = '';
    isChargingCountings = true;

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '$baseUrl/Inventory/GetCountings?inventoryProcessCode=$inventoryProcessCode'));
      request.body = json.encode(
        userIdentity,
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseInString = await response.stream.bytesToString();
      final List responseInList = json.decode(responseInString);
      final Map responseInMap = responseInList.asMap();

      print(responseInMap);

      responseInMap.forEach((id, data) {
        _countings.add(
          Countings(
            codigoInternoInvCont: data['CodigoInterno_InvCont'],
            flagTipoContagemInvCont: data['FlagTipoContagem_InvCont'],
            codigoInternoInventario: data['CodigoInterno_Inventario'],
            numeroContagemInvCont: data['NumeroContagem_InvCont'],
            obsInvCont: data['Obs_InvCont'] == null
                ? 'Não há observações'
                : data['Obs_InvCont'],
            //as vezes a observação vem nula e se não faz isso, gera erro no app
          ),
        );
      });
    } catch (e) {
      countingsErrorMessage =
          'O servidor não foi encontrado. Verifique a sua internet!';
    } finally {
      isChargingCountings = false;
    }

    notifyListeners();
  }
}
