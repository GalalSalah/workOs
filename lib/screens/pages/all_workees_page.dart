import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/services/global_methods.dart';
import 'package:work_os/widget/all_workers_widget.dart';
import 'package:work_os/widget/drawer_widget.dart';
import 'package:work_os/widget/task_widget.dart';

class AllWorkersPage extends StatefulWidget {
  const AllWorkersPage({Key? key}) : super(key: key);

  @override
  State<AllWorkersPage> createState() => _AllWorkersPageState();
}

class _AllWorkersPageState extends State<AllWorkersPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Constant.backgroundColor,
        drawer: DrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Constant.backgroundColor,
          elevation: 0,
          title: Text(
            'All workers',
            style: TextStyle(
                color: Constant.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 29),
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
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AllWorkerWidget(
                        userID: snapshot.data!.docs[index]['uid'],
                        phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                        positionInCompany: snapshot.data!.docs[index]
                            ['positionInCompany'],
                        userEmail: snapshot.data!.docs[index]['email'],
                        userImageUrl: snapshot.data!.docs[index]['imageUrl'],
                        userName: snapshot.data!.docs[index]['name'],
                      );
                    });
              } else {
                return const Center(
                  child: Text('There is no users'),
                );
              }
            }
            return const Center(
                child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ));
          },
        )
        // body: StreamBuilder<QuerySnapshot>(
        //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return  Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       } else if (snapshot.connectionState == ConnectionState.active) {
        //         if (snapshot.data!.docs.isNotEmpty) {
        //           return ListView.builder(
        //               itemCount: snapshot.data!.docs.length,
        //               itemBuilder: (BuildContext context, int index) {
        //                 return AllWorkersPage();
        //               });
        //         } else {
        //           return const Center(
        //             child: Text('There is no users'),
        //           );
        //         }
        //
        //       }
        //       return Center(
        //         child: Text(
        //           'Something went wrong',
        //           style: TextStyle(
        //               color: Constant.textColor, fontWeight: FontWeight.bold),
        //         ),
        //       );
        //
        //     }),
        );
  }
}
