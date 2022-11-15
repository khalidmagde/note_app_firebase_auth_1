import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_1/pages/addnotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*  @override
  void initState() {
    addData();
    super.initState();
  } */

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerusername = TextEditingController();

  addData() async {
    CollectionReference userdata =
        FirebaseFirestore.instance.collection('user');
    userdata.add({
      'username': _controllerusername.text,
      'email': _controllerEmail.text,
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        username: _controllerusername.text,
      );
      addData();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text("Firebase Auth");
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool val,
  ) {
    return TextField(
      obscureText: val,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _entryFieldUser(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _Logo(String img) {
    return Center(
      child: Image.asset(img),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (isLogin) {
          signInWithEmailAndPassword();
        } else {
          createUserWithEmailAndPassword();
          print('==============');
        }
      },
      //isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login Instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: isLogin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _Logo('images/logo.png'),
                    _entryField('email', _controllerEmail, false),
                    _entryField('password', _controllerPassword, true),
                    _errorMessage(),
                    _submitButton(),
                    _loginOrRegisterButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _Logo('images/logo.png'),
                    _entryFieldUser('username', _controllerusername),
                    _entryField('email', _controllerEmail, false),
                    _entryField('password', _controllerPassword, true),
                    _errorMessage(),
                    _submitButton(),
                    _loginOrRegisterButton(),
                  ],
                )),
    );
  }
}
