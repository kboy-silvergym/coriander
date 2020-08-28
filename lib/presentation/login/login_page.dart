import 'package:coriander/presentation/book_list/book_list_page.dart';
import 'package:coriander/presentation/login/login_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'example@kboy.com',
                    ),
                    controller: mailController,
                    onChanged: (text) {
                      model.mail = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'パスワード',
                    ),
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  RaisedButton(
                    child: Text('ログインする'),
                    onPressed: () async {
                      try {
                        await model.login();
                        await _showDialog(context, 'ログインしました');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookListPage()),
                        );
                      } catch (e) {
                        _showDialog(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
