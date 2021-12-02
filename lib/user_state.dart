import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/screens/auth/login.dart';
import 'package:work_os/screens/pages/task_page.dart';

class UserState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.data == null) {
            return Login();
          } else if (userSnapShot.hasData) {
            return TaskPage();
          } else if (userSnapShot.hasError) {
            return  const Scaffold(
              body: Center(
                child: Text('An error occurred'),
              ),
            );
          }
          else if (userSnapShot.connectionState==ConnectionState.waiting) {
            return  Scaffold(
              body: Center(
                child:CircularProgressIndicator(backgroundColor: Constant.backgroundColor,)
              ),
            );
          }
          else {
            return Scaffold(
              body: CircularProgressIndicator(
                color: Constant.backgroundColor,
              ),
            );
          }
        });
  }
}
