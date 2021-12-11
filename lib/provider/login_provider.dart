import 'dart:convert';

import 'package:celta_inventario/models/enterprise.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  List<Enterprise> _enterprises = [];

  List<Enterprise> get enterprises {
    return [..._enterprises];
  }

  bool auth = false;

  bool get isAuth {
    if (auth == false) {
      return false;
    } else {
      return true;
    }
  }

  String loginMessage = '';

  String errorMessage(String error) {
    if (error ==
        '{Message: O usuário não foi encontrado durante a tentativa de efetuar o login no Celta Business Solutions. Fale com nosso suporte técnico para que o problema seja resolvido.}') {
      loginMessage = 'Usuário não encontrado!';
    } else if (error ==
        '{Message: A senha está incorreta. Verifique a configuração do teclado e se a tecla [CAPS LOCK] está pressionada. Caso você tenha esquecido sua senha entre em contato com o administrador do seu sistema.}') {
      loginMessage = 'A senha está incorreta!';
    } else if (error.contains('Connection timed')) {
      loginMessage = 'Servidor não encontrado. Verifique a sua internet';
    } else {
      error = '';
      auth = true;
      loginMessage = '';
    }
    auth = true;
    return '';
  }

  login([String user = '', String password = '']) async {
    String error = '';
    try {
      final response = await http.post(
        Uri.parse(
          'http://192.168.100.174:34603/api/Security/UserCanLoginPlain?user=$user&password=$password',
        ),
      );
      var responseOfUser = json.decode(response.body);
      String responseInString = responseOfUser.toString();
      loginMessage = responseInString;
    } catch (e) {
      print(e);
      error = e.toString();
      loginMessage = error;
      errorMessage(loginMessage);
    } finally {
      //pega o retorno do login e coloca na variável "loginMessage" pra ter acesso a mensagem na tela de autenticação e exibir a mensagem de erro
      errorMessage(error);
    }

    notifyListeners();
  }

  doAuth() {
    if (isAuth) {
      login();
    }
  }

  Future getEnterprises() async {
    if (_enterprises.isNotEmpty) {
      _enterprises.clear();
    }

    try {
    var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://192.168.100.174:34603/api/Enterprise/GetEnterprises'));
      request.body = json.encode(
          "¬EncryptedDataInfo£¬EncryptedData£zFU/ChZcnVrG7+GL3Jw2t+9MFhKc3XAzUN+jwgNNLtvcDOcqWy71Wh/+5/TE2wh5gJrVI7wiUVsybH/z9aI6yq3tWJAn2vklx9ylc/HceLfQJ1fBhXgfHLnOuP1dxls/xOPwHxo4GL8MXPzpGvEoQbAlLNrzU5WzcDGrOgv0yNijAJcwIpvivgYlvGKl0zGXQqpn3Ctx9X4TB4YRV7tUzeaYHxI4ZhKwzKXJxAM9fM2t6RxmE4NdIidygj/Cp7mgJZ6N1HNH6rlwYyLYcPcupNkbVgaQs/z/y1/qikUV+VUJydUYmw48G+PwHd2WMmLs9h1l7rLuxXclU5DT61bHlHScsEQanIUviX0BbhMlAXsmdYCDwG1yAg6dk8DsIHR0p1B5Pv6kS8F0elywus2GXnRXNs+w3K8X¬/EncryptedData£¬EncryptedIV£UsgMfHU9ABHKJqtyt9Nr8pXsRFQI20KHdjTXG4bKQ9kOv9/rSIoiq5m6JqgMTGOeIzm3Fm6sAUTtlGuGFiUJS2bK91M6yKWXwsyW0vgHzdk7AWs+9Rw0YOMJ6FYUE1ENLzfXm7gQJIyxuUy4xdeHRNWBHVk19b00mWDD2xQfkxA=¬/EncryptedIV£¬EncryptedKey£nyPCcup6vNvc3cGq5+FFQG0QbM6j3lFChm1R/Ko0pWriWOqV15JeeO+CYd/CfAjr1PE8HdwTk0uMqVqirUFeZLXuvsM9d6WQATuPddfw8PctmQ73alwOvkjPDkKYS9wrRfijHRTSZ85ESCDjmqouW91Hrmi5MUpwkqwO0bZ0N1o=¬/EncryptedKey£¬/EncryptedDataInfo£");
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
      e;
      print(e.toString());
    } finally {}

    notifyListeners();
  }

  int get itemCount {
    return _enterprises.length;
  }

  Future logout() async {
    auth = false;
    notifyListeners();
  }
}
