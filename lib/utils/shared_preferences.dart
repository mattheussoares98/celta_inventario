//ideal pra salvar poucos dados no celular. Pra salvar bastante informações, o ideal é usar o sqflite

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

TextEditingController _controller = TextEditingController();

String _digitado = 'Nada salvo';

class _HomePageState extends State<HomePage> {
  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _controller.text);
    print('salvo');
  }

  _remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    setState(() {
      _digitado = 'Nada salvo';
    });
    print('removido');
  }

  _restore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _digitado = prefs.getString('name') ?? 'Nada salvo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manipulação de dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: Column(
          children: [
            Text(_digitado),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                label: Text('Digite algo'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: _restore,
                  child: const Text('Recuperar'),
                ),
                ElevatedButton(
                  onPressed: _remove,
                  child: const Text('Remover'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
