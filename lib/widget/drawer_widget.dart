import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/screens/inner_screens/add_task.dart';
import 'package:work_os/screens/inner_screens/profile.dart';
import 'package:work_os/screens/pages/all_workees_page.dart';
import 'package:work_os/screens/pages/task_page.dart';

import '../user_state.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            child: Column(
              children: [
                Flexible(
                  child: Image.network(
                      'https://image.flaticon.com/icons/png/128/1055/1055672.png'),
                  flex: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Text(
                    'Work OS',
                    style: TextStyle(
                        color: Constant.textColor,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _listTile(
              label: 'All Task',
              fct: () {
                _navigateToAllTaskScreen(context);
              },
              icon: Icons.task_outlined),
          _listTile(label: 'My Account', fct: () {
            _navigateToMyAccount();
          }, icon: Icons.settings),
          _listTile(
              label: 'Register Workers',
              fct: () {
                _navigateToAllWorkersPage(context);
              },
              icon: Icons.workspaces_outline),
          _listTile(
              label: 'Add Task',
              fct: () {
                _navigateToAddTask(context);
              },
              icon: Icons.add_task),
          const Divider(
            thickness: 2,
          ),
          _listTile(
              label: 'Logout',
              fct: () {
                _signOut(context);
              },
              icon: Icons.logout),
        ],
      ),
    );
  }

  void _navigateToAllWorkersPage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllWorkersPage()));
  }

  void _navigateToAddTask(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
  }

  void _navigateToMyAccount() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userId: uid,)));
  }

  void _navigateToAllTaskScreen(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TaskPage()));
  }

  void _signOut(context) {
    final FirebaseAuth _auth=FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/1252/1252006.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Logout'),
                )
              ],
            ),
            content: Text(
              'Do you wanna sign out',
              style: TextStyle(
                  color: Constant.textColor,
                  fontSize: 22,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                      builder: (context) => UserState(),
                  ),);

                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  Widget _listTile(
      {required String label, required Function fct, required IconData icon}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Constant.textColor,
      ),
      onTap: () {
        fct();
      },
      title: Text(
        label,
        style: TextStyle(
            color: Constant.textColor,
            fontSize: 22,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
