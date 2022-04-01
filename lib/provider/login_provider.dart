import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class LoginProvider with ChangeNotifier {
  String errorMessage = '';

  _errorMessage(String error) {
    if (error.contains('O usuário não foi encontrado')) {
      errorMessage = 'Usuário não encontrado!';
    } else if (error.contains('senha está incorreta')) {
      errorMessage = 'A senha está incorreta!';
    } else if (error.contains('Connection timed out')) {
      errorMessage = 'Time out! Tente novamente!';
    } else if (error.contains('Connection')) {
      errorMessage = 'O servidor não foi encontrado. Verifique a sua internet';
    } else if (error.contains('Software caused connection abort')) {
      errorMessage = 'Conexão abortada. Tente novamente';
    } else if (error.contains('No host specifie')) {
      errorMessage = 'URL inválida!';
    } else if (error.contains('Failed host lookup')) {
      errorMessage = 'URL inválida!';
    } else if (error.contains('FormatException')) {
      errorMessage = 'URL inválida!';
    } else if (error.contains('Invalid port')) {
      errorMessage = 'Url inválida!';
    } else if (error.contains('No route')) {
      errorMessage = 'Servidor não encontrado!';
    } else {
      errorMessage = 'Servidor indisponível';
    }
  }

  static bool _isAuth = false;

  bool get isAuth {
    return _isAuth;
  }

  static MultiStreamController<bool>? _controller;
  static final _isAuthStream = Stream<bool>.multi((controller) {
    _controller = controller;

    //esse stream está sendo usado no AuthOrHomePage
    //quando da certo o login, ele adiciona o _isAuth no controller
  });

  Stream get authStream {
    return _isAuthStream;
  }

  login({
    String? user,
    String? password,
    String? baseUrl,
  }) async {
    errorMessage = '';
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
        _isAuth = true;
        _controller?.add(_isAuth);
        print('deu certo');
      } else {
        print('Erro no login');
        _errorMessage(response.body);
      }
    } catch (e) {
      _errorMessage(e.toString());
      print('deu erro no login: $e');
      notifyListeners();
    }
  }

  logout() {
    _isAuth = false;
    _controller?.add(_isAuth);
  }
}
