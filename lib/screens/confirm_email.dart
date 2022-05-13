import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/texts_styles.dart';
import 'login_page.dart';

class ConfirmEmail extends StatelessWidget {
  static String id = 'confirm-email';
  final String message;

  const ConfirmEmail({required Key key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Email Confirmation"),
          backgroundColor: ColorStyle.green,
        ),
        body: Column(
          children: [
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                              color: ColorStyle.black, fontSize: 16),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign In',
                            style: TextStyles.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        )
                      ],
                    ))),
          ],
        ));
  }
}
