import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/screens/auth/login.dart';
import 'package:work_os/screens/inner_screens/profile.dart';
import 'package:work_os/screens/inner_screens/task_details.dart';
import 'package:work_os/user_state.dart';

import 'screens/pages/task_page.dart';

void main() {
  WidgetsFlutterBinding();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Constant.backgroundColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: Constant.textColor,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Constant.backgroundColor,
                body: Center(
                  child: Text(
                    'Mmmmmm, Something wrong',
                    style: TextStyle(
                        color: Constant.textColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          } else {
           return MaterialApp(
              title: 'Flutter WorkOs',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              home:  UserState(),
            );
          }
        });
  }
}
