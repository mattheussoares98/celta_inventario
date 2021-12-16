import 'package:celta_inventario/models/inventory.dart';
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
  String inventoryErrorMessage = '';
  Future<void> getInventory(String enterpriseCode) async {
    isChargingInventorys = true;
    _inventorys.clear();
    inventoryErrorMessage = '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            'http://192.168.100.174:34603/api/Inventory/GetFroozenProcesses?enterpriseCode=$enterpriseCode'),
      );
      request.body = json.encode(
          "¬EncryptedDataInfo£¬EncryptedData£LWtZl6CLFCTOVzlELFgTpCFSmnVszQEwvSaI8ILAqsQRjfqsUA9b2vt8/D0KqYaGfCMSVG5hJU5y200WXB64qGNzLcwuY3k2CHdRXZSnZqNMKzNu4M/gQ2FnibOScf7eqbDjLgkBUNYt9YXK/d9GvlSH2cuAFLGx0uighYRMy6FET9gbyqaPA5gZUaiySrhIhiqHHp/14qBRdQtzYqW1/XNuo4oG1RXSvXJWMeQ+AF07hAnRXUwLlH5nzRLR4LeAvJvMm1oh7lAI6ieHXnDaS2FLD1hyFsTiAaZ/Zecrefk0bWd96tjlck+5P9FR7rKo4ZElGLJwVeRCMsD9v13TeK6nYcuZOnQo+5cEHJhS7GaN0TPJ3qG3bigB6jEWhwDizH8Y4MDIcmcpDV60Q4zIT/+0BpbeCZio¬/EncryptedData£¬EncryptedIV£FE4MfmTvhvPuT2TOrw1gKSkvQCZ9EUxrIbIWDT6mFBtH1DgQ3+pLyMhtnW/1EqPQK2dtrOu9rbPrjY74XwAS8Il6Jej8+/zJZ24mv9fTxj/HgLAFtEbBmiBs9CuGXQYw8XC+g+faq3/+4XrsXSnP9VuC7Rv9IRU5jdPByd3VAeA=¬/EncryptedIV£¬EncryptedKey£sprQMTpv65da9DDoIRVS0hxa/+G91vmsMgkHrvd9fGgqebW8qs0wRF6jzXpwX2MaQzpi/bfrac2XqLOMDpS0gMPdUMBkwI+UCTbiMnJlulCWTxtlZYKojb6DcK2Wtf0BS8hWBp/z+UYWTEWiCq0ctYSwwpHzQ0wK7bGGGjdXi9U=¬/EncryptedKey£¬/EncryptedDataInfo£");
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
      print('error $e');

      inventoryErrorMessage =
          'O servidor não foi encontrado! Verifique a sua internet!';
    } finally {
      isChargingInventorys = false;
    }

    notifyListeners();
  }
}
