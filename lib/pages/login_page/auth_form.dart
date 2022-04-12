import 'package:celta_inventario/pages/login_page/login_provider.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AuthForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

TextEditingController _urlController = TextEditingController();
TextEditingController _userController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _AuthFormState extends State<AuthForm> {
  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  @override //essa função serve para liberar qualquer tipo de memória que esteja sendo utilizado por esses FocusNode e Listner
  void dispose() {
    super.dispose();
    _passwordController.clear();
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    _urlFocusNode.dispose();
  }

  _saveUserAndUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', _urlController.text);
    await prefs.setString('user', _userController.text);
  }

  _submit({required LoginProvider loginProvider}) async {
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    await _saveUserAndUrl();

    await loginProvider.login(
      user: _userController.text,
      password: _passwordController.text,
      baseUrl: _urlController.text,
    );

    if (loginProvider.errorMessage != '') {
      ShowErrorMessage().showErrorMessage(
        error: loginProvider.errorMessage,
        context: context,
      );
    }

    BaseUrl.url = _urlController.text;
  }

  _restoreUserAndUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //logo que instala o app, logicamente ainda não tem nada salvo nas URLs
    //se não fizer essa verificação, vai dar erro no debug console
    if (prefs.getString('url') == null || prefs.getString('user') == null) {
      return;
    }

    _urlController.text = prefs.getString('url')!;
    _userController.text = prefs.getString('user')!;
  }

  @override
  void initState() {
    super.initState();
    _restoreUserAndUrl();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider = Provider.of(context, listen: true);

    return Card(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                enabled: _loginProvider.isLoading ? false : true,
                controller: _userController,
                focusNode: _userFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocusNode),
                validator: (_name) {
                  _name = _userController.text;
                  if (_userController.text.trim().isEmpty) {
                    return 'Preencha o nome';
                  }
                  return null;
                },
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                  decorationColor: Colors.black,
                  color: Colors.black,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  labelText: 'Usuário',
                  counterStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                enabled: _loginProvider.isLoading ? false : true,
                focusNode: _passwordFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_urlFocusNode),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                  decorationColor: Colors.black,
                  color: Colors.black,
                  fontSize: 20,
                ),
                validator: (_name) {
                  _name = _passwordController.text;
                  if (_passwordController.text.trim().isEmpty) {
                    return 'Preencha a senha';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
              ),
              TextFormField(
                enabled: _loginProvider.isLoading ? false : true,
                controller: _urlController,
                onFieldSubmitted: (_) => _submit(loginProvider: _loginProvider),
                focusNode: _urlFocusNode,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                  decorationColor: Colors.black,
                  color: Colors.black,
                  fontSize: 20,
                ),
                validator: (_url) {
                  _url = _urlController.text;
                  if (_urlController.text.trim().isEmpty) {
                    return 'Preencha a url';
                  } else if (!_urlController.text.contains('http') ||
                      !_urlController.text.contains('//') ||
                      !_urlController.text.contains(':')) {
                    return 'URL inválida';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'URL',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60),
                  maximumSize: Size(double.infinity, 60),
                ),
                onPressed: _loginProvider.isLoading
                    ? null
                    : () => _submit(
                          loginProvider: _loginProvider,
                        ),
                child: _loginProvider.isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FittedBox(
                          child: Row(
                            children: [
                              const Text(
                                'Efetuando login...',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 16,
                                width: 16,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
