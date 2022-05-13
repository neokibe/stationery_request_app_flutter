import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stationery_request_app/screens/login_page.dart';
import 'package:stationery_request_app/screens/splash_screen.dart';

void main() async {
  //Initialising Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stationery Request App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: SplashScreen(),
    );
  }
}