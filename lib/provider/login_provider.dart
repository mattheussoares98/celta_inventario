import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
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

  Future logout() async {
    auth = false;
    notifyListeners();
  }
}
