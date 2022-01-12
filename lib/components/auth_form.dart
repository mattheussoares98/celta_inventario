import 'package:celta_inventario/provider/login_provider.dart';
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

final Map<String, String> _data = {
  'user': '',
  'password': '',
};
// final _key = GlobalKey<FormState>();

class _AuthFormState extends State<AuthForm> {
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

  _submit() async {
    final _loginProvider = Provider.of<LoginProvider>(context, listen: false);
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _loginProvider.login(_data['user']!, _data['password']!);
      if (_loginProvider.loginErrorMessage != '') {
        errorMessage(_loginProvider.loginErrorMessage);
      }
    } catch (e) {
      e;
    } finally {
      setState(() {
        _isLoading = false;
        if (_loginProvider.isAuth) {
          _data['user'] = '';
          _data['password'] = '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
