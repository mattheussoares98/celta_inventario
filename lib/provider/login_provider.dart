import 'dart:convert';
import 'package:celta_inventario/utils/base_url.dart';
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

  String loginErrorMessage = '';

  errorMessage(String error) {
    if (error.contains('O usuário não foi encontrado')) {
      loginErrorMessage = 'Usuário não encontrado!';
    } else if (error ==
        '{Message: A senha está incorreta. Verifique a configuração do teclado e se a tecla [CAPS LOCK] está pressionada. Caso você tenha esquecido sua senha entre em contato com o administrador do seu sistema.}') {
      loginErrorMessage = 'A senha está incorreta!';
    } else if (error.contains('Connection timed')) {
      loginErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
    } else if (error.contains('No host specifie')) {
      loginErrorMessage = 'URL inválida';
    } else {
      error = '';
      auth = true;
      loginErrorMessage = '';
    }
  }

  login({
    String? user,
    String? password,
    String? baseUrl,
  }) async {
    String error = '';

    try {
      final response = await http.post(
        Uri.parse(
          '${BaseUrl().baseUrl}/Security/UserCanLoginPlain?user=$user&password=$password',
        ),
      );
      var responseOfUser = json.decode(response.body);
      String responseInString = responseOfUser.toString();
      loginErrorMessage = responseInString;
    } catch (e) {
      error = e.toString();
      loginErrorMessage = error;
      errorMessage(loginErrorMessage);
    } finally {
      //pega o retorno do login e coloca na variável "loginErrorMessage" pra ter acesso a mensagem na tela de autenticação e exibir a mensagem de erro
      errorMessage(loginErrorMessage);
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
