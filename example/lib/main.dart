import 'package:dio/dio.dart';
import 'package:example/config.dart';
import 'package:example/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_okta/flutter_okta.dart';
import 'package:tuple/tuple.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Okta example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset('assets/ic_google.png'),
                  onPressed: () async {
                    final Tuple2<String, String> res = await FlutterOkta.I
                        .openIdSocialLogin(context, googleIdpId, oktaDomain,
                            oktaClientId, oktaRedirectUri);
                    setState(() {
                      info = 'idToken: ${res.item1}\naccessToken: ${res.item2}';
                    });
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/ic_facebook.png'),
                  onPressed: () async {
                    final Tuple2<String, String> res = await FlutterOkta.I
                        .openIdSocialLogin(context, facebookIdpId, oktaDomain,
                            oktaClientId, oktaRedirectUri);
                    setState(() {
                      info = 'idToken: ${res.item1}\naccessToken: ${res.item2}';
                    });
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/ic_linkedin.png'),
                  onPressed: () async {
                    final Tuple2<String, String> res = await FlutterOkta.I
                        .openIdSocialLogin(context, linkedinIdpId, oktaDomain,
                            oktaClientId, oktaRedirectUri);
                    setState(() {
                      info = 'idToken: ${res.item1}\naccessToken: ${res.item2}';
                    });
                  },
                ),
              ],
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
              child: Text('Login'),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final Response<Map<String, dynamic>> res = await FlutterOkta.I
                    .restLogin(oktaDomain, emailController.text,
                        passwordController.text);
                setState(() {
                  info = res.data.toString();
                });
              },
            ),
            FlatButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => RegisterPage()));
              },
            ),
            SelectableText(info ?? ''),
          ],
        ),
      ),
    );
  }
}
