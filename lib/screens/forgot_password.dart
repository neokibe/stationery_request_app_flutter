import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/colors.dart';
import '../utils/validator.dart';
import '../widgets/neo_button.dart';
import 'confirm_email.dart';
import 'login_page.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';
  final String message =
      "An email has just been sent to you, Click the link provided in your email to complete password reset";

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final String _email = "neokibe5@gmail.com";
  final _emailTextController = TextEditingController();
  final bool _loginfail = false;
  final _focusEmail = FocusNode();

  // function for password reset
  _passwordReset() async {
    try {
      _formKey.currentState?.save();
      await _auth.sendPasswordResetEmail(email: _email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ConfirmEmail(
            message: widget.message,
            key: _formKey,
          );
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reset Your Password"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const BlackBar(),
              Center(
                heightFactor: 3.0,
                child: Form(
                  // autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Please type in your email:',
                            style: TextStyle(
                                fontSize: 20, color: ColorStyle.black),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                decoration: InputDecoration(
                                  errorText:
                                      _loginfail ? 'email not match' : null,
                                  labelText: "Email",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          NeoButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _passwordReset();
                                  log(_email);
                                }
                              },
                              buttonText: 'Send reset email'),
                          const SizedBox(
                            height: 10,
                            width: 10,
                          ),
                          TextButton(
                            child: const Text('Back to sign in page',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
