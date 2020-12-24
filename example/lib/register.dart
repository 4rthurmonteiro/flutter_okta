import 'package:dio/dio.dart';
import 'package:example/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_okta/flutter_okta.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: 'First name',
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintText: 'Last name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            RaisedButton(
              child: Text('Register'),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final Response<Map<String, dynamic>> res = await FlutterOkta.I
                    .restRegister(
                        oktaDomain,
                        oktaApiKey,
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text);

                setState(() {
                  info = res.data.toString();
                });
              },
            ),
            SelectableText(info ?? ''),
          ],
        ),
      ),
    );
  }
}
