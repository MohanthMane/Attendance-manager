import 'package:attendance_manager/Services/AuthManager.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  double width, height;
  @override
  Widget build(BuildContext context) {
    this.width = MediaQuery.of(context).size.width;
    this.height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: _signInButton(),
        ));
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await signInWithGoogle().then((value) {
          Navigator.of(context).pushReplacementNamed('home');
        }).catchError((e) {});
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/google_logo.png"),
                height: this.height / 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
