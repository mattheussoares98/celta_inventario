import 'dart:convert';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class LoginProvider with ChangeNotifier {
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
    } else if (error.contains('senha está incorreta')) {
      loginErrorMessage = 'A senha está incorreta!';
    } else if (error.contains('Connection timed out')) {
      loginErrorMessage = 'Time out! Tente novamente!';
    } else if (error.contains('Connection')) {
      loginErrorMessage =
          'O servidor não foi encontrado. Verifique a sua internet';
    } else if (error.contains('Software caused connection abort')) {
      loginErrorMessage = 'Conexão abortada. Tente novamente';
    } else if (error.contains('No host specifie')) {
      loginErrorMessage = 'URL inválida!';
    } else if (error.contains('Failed host lookup')) {
      loginErrorMessage = 'URL inválida!';
    } else if (error.contains('FormatException')) {
      loginErrorMessage = 'URL inválida!';
    } else if (error.contains('Invalid port')) {
      loginErrorMessage = 'Url inválida!';
    } else if (error.contains('No route')) {
      loginErrorMessage = 'Servidor não encontrado!';
    } else {
      loginErrorMessage = 'Servidor indisponível';
    }
  }

  login({
    String? user,
    String? password,
    String? baseUrl,
  }) async {
    loginErrorMessage = '';
    String error = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/Security/UserCanLoginPlain?user=$user&password=$password',
        ),
      );

      var responseOfUser = json.decode(response.body);

      //transformando o XML em String pra pegar a identidade do usuário
      final myTransformer = Xml2Json();

      //se não colocar essa condição, a validação do login fica errada porque tenta converter algo nulo
      if (responseOfUser[0] != null) {
        myTransformer.parse(responseOfUser[0]['CrossIdentity_Usuario']);
        String toParker = myTransformer.toParker();
        Map toParker2 = json.decode(toParker);
        UserIdentity.identity = toParker2['string'];
      }

      if (response.statusCode == 200) {
        _auth = true;
      } else {
        print('Erro no login');
        error = response.body;
        errorMessage(error);
      }
    } catch (e) {
      print('deu erro no login: $e');
      error = e.toString();
      errorMessage(error);
    }

    notifyListeners();
  }

  doAuth() {
    if (isAuth) {
      login();
    }
  }

  logout() {
    _auth = false;
    notifyListeners();
  }
}
