import 'dart:convert';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class LoginProvider with ChangeNotifier {
  String? userIdentity;

  bool _auth = false;

  bool get isAuth {
    if (_auth == false) {
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

      //transformando o XML em String pra pegar a identidade do usuário
      final myTransformer = Xml2Json();
      myTransformer.parse(responseOfUser[0]['CrossIdentity_Usuario']);
      String toParker = myTransformer.toParker();
      Map toParker2 = json.decode(toParker);
      userIdentity = toParker2['string'];

      print(userIdentity);
      if (response.statusCode == 200) {
        _auth = true;
      }
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loginErrorMessage = error;
      errorMessage(loginErrorMessage);
      print('deu erro no login: $e');
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
    _auth = false;
    notifyListeners();
  }
}
