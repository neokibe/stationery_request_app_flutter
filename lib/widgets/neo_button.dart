import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NeoButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;

  const NeoButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(buttonText),
        style: ElevatedButton.styleFrom(
          // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          primary: ColorStyle.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
