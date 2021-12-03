import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/services/global_methods.dart';
import 'package:work_os/widget/drawer_widget.dart';
import 'package:work_os/widget/task_widget.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: DrawerWidget(),
        backgroundColor: Constant.backgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          // leading: Builder(
          //   builder: (ctx) => IconButton(
          //     onPressed: () => Scaffold.of(ctx).openDrawer(),
          //     icon: const Icon(
          //       Icons.menu,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          backgroundColor: Constant.backgroundColor,
          elevation: 0,
          title: Text(
            'Tasks',
            style: TextStyle(
                color: Constant.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  GlobalMethod.showTaskCategory(

                    context: context,
                    size: size,
                  );
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  color: Colors.black,
                ))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext ctx, int index) => TaskWidget(
                          isDone: snapshot.data!.docs[index]['isDone'],
                          taskDescription: snapshot.data!.docs[index]
                              ['taskDescription'],
                          taskId: snapshot.data!.docs[index]['TaskId'],
                          taskTitle: snapshot.data!.docs[index]['taskTitle'],
                          uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                        ));
              } else {
                return Center(
                  child: Text(
                    'There is no Tasks',
                    style: TextStyle(
                        color: Constant.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                );
              }
            }
            return const Center(
                child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ));
          },
        ));
  }
}
