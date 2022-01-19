import 'package:celta_inventario/models/inventory.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryProvider with ChangeNotifier {
  final List<Inventory> _inventorys = [];

  List<Inventory> get inventorys {
    return [..._inventorys];
  }

  int get inventoryCount {
    return _inventorys.length;
  }

  bool isChargingInventorys = false;
  bool haveError = false;
  String inventoryErrorMessage = '';

  Future<void> getInventory({
    String? enterpriseCode,
    String? userIdentity,
  }) async {
    haveError = false;
    isChargingInventorys = true;
    _inventorys.clear();
    inventoryErrorMessage = '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl().baseUrl}/Inventory/GetFroozenProcesses?enterpriseCode=$enterpriseCode'),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseAsString = await response.stream.bytesToString();

      //esse if serve para quando não houver um inventário congelado para a empresa, não continunar o processo senão dará erro na aplicação
      if (responseAsString
          .contains('Nenhum processo de inventário foi encontrado')) {
        inventoryErrorMessage =
            'Não há processos de inventário para essa empresa. Somente processos de inventário congelados ficarão disponíveis para consulta e seleção.';
        isChargingInventorys = false;
        notifyListeners();
        return;
      }

      List responseAsList = json.decode(responseAsString.toString());
      Map responseAsMap = responseAsList.asMap();

      responseAsMap.forEach((id, data) {
        _inventorys.add(
          Inventory(
            codigoInternoInventario: data['CodigoInterno_Inventario'],
            dataCriacaoInventario:
                DateTime.parse(data['DataCriacao_Inventario']),
            dataCongelamentoInventario:
                DateTime.parse(data['DataCongelamento_Inventario']),
            nomeTipoEstoque: data['Nome_TipoEstoque'],
            obsInventario: data['Obs_Inventario'] ?? '',
            nomefuncionario: data['Nome_Funcionario'],
            nomeempresa: data['Nome_Empresa'],
            codigoInternoEmpresa: data['CodigoInterno_Empresa1'],
            codigoEmpresa: data['Codigo_Empresa'],
          ),
        );
      });
    } catch (e) {
      //sempre que cair aqui no erro, é porque não conseguiu acessar o servidor
      //por isso vou deixar essa mensagem padrão

      inventoryErrorMessage =
          'O servidor não foi encontrado! Verifique a sua internet!';
      haveError = true;
    } finally {
      isChargingInventorys = false;
    }

    notifyListeners();
  }
}
