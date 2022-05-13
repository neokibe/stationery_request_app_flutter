import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stationery_request_app/constants/colors.dart';
import 'package:stationery_request_app/constants/texts_styles.dart';
import 'package:stationery_request_app/model/user_model.dart';
import 'package:stationery_request_app/utils/fire_auth.dart';
import 'package:stationery_request_app/utils/validator.dart';

import '../widgets/neo_button.dart';
import 'forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscured = true;
  bool _loginfail = false;
  late final String role;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

//todo: move this to own class
  Future getUser(uid) async {
    return FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(uid)
        .get()
        .then((value) {
      // print(user);
      loggedInUser = UserModel.fromMap(value.data());
      print(loggedInUser);
    }).whenComplete(() {
      log(loggedInUser.toString());
      const CircularProgressIndicator();
      //  role = loggedInUser.role.toString();

      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background 2.jpg'),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: ColorStyle.transparent,
          // appBar: AppBar(
          //   backgroundColor: ColorStyle.red,
          // ),
          body: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //  const BlackBar(),

                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                      ),
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: ColorStyle.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/stationery_logo.jpg'),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      const Text("Please enter your details to log in",
                          style: TextStyles.sizeA),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      //todo: extract form widget to prevent whole page rebuilding
                      Form(
                        // Used to configure validation of form widgets and Formfields
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                autofocus: true,
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
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: _obscured,
                                validator: (value) =>
                                    Validator.validatePassword(
                                  password: value,
                                ),
                                decoration: InputDecoration(
                                  errorText:
                                      _loginfail ? 'password not match' : null,
                                  labelText: "Password",

                                  //Show/hide password functionality
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscured = !_obscured;
                                      });
                                    },
                                    icon: _obscured
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const SizedBox(
                              height: 5.0,
                            ),
                            if (_isProcessing)
                              const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorStyle.black),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      //Navigating to forgot password screen
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyles.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 10,
                                  ),
                                  NeoButton(
                                      onTap: () async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isProcessing = true;
                                          });

                                          user = await FireAuth
                                              .signInUsingEmailPassword(
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );
                                          user =
                                              FirebaseAuth.instance.currentUser;

                                          if (user != null) {
                                            log(user!.uid);

                                            // loadImage(user?.uid);
                                            getUser(user?.uid).then((value) {
                                              setState(() {
                                                _isProcessing = false;
                                              });

                                              //  Navigating to the home page
                                              if (user != null) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              }
                                              // if user does not exist, print error message
                                              else {
                                                setState(() {
                                                  _loginfail = true;
                                                });
                                              }
                                            });
                                          }
                                        }
                                      },
                                      buttonText: 'Sign in'),
                                ],
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorStyle.black),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
