import 'package:celta_inventario/provider/login_provider.dart';
import 'package:celta_inventario/utils/db_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AuthForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final Map<String, String> _data = {
    'user': '',
    'password': '',
    'url': '',
  };

  bool _isLoading = false;

  errorMessage(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool isLoaded = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    LoginProvider loginProvider = Provider.of(context, listen: true);
    if (!isLoaded) {
      await loginProvider.loadUrl();

      _data['url'] = loginProvider.userBaseUrl!;
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider =
        Provider.of<LoginProvider>(context, listen: true);
    _submit() async {
      bool isValid = widget.formKey.currentState!.validate();
      await _loginProvider.loadUrl();

      if (!isValid) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await _loginProvider.login(
          user: _data['user']!,
          password: _data['password']!,
          baseUrl: _data['url'],
        );
        if (_loginProvider.loginErrorMessage != '') {
          errorMessage(_loginProvider.loginErrorMessage);
        }
      } catch (e) {
        e;
      } finally {
        setState(() {
          _isLoading = false;
          if (_loginProvider.isAuth) {
            _data['password'] = '';
          }
        });
      }
    }

    return !isLoaded
        ? Card()
        : Card(
            margin: const EdgeInsets.all(20),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (_name) {
                        _name = _data['user'];
                        if (_data['user']!.trim().isEmpty) {
                          return 'Preencha o nome';
                        }
                        return null;
                      },
                      initialValue: _data['user'],
                      onChanged: (value) => _data['user'] = value,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      validator: (_name) {
                        _name = _data['password'];
                        if (_data['password']!.trim().isEmpty) {
                          return 'Preencha a senha';
                        }
                        return null;
                      },
                      initialValue: _data['password'],
                      onChanged: (value) => _data['password'] = value,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      onChanged: (value) => _data['url'] = value,
                      initialValue: !isLoaded ? '' : _loginProvider.userBaseUrl,
                      validator: (_url) {
                        _url = _data['url'];
                        if (_data['url']!.trim().isEmpty) {
                          return 'Preencha a url';
                        } else if (!_data['url']!.contains('http') ||
                            !_data['url']!.contains('//') ||
                            !_data['url']!.contains(':')) {
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
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
