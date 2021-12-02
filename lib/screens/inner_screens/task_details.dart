import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'package:work_os/constant/constant.dart';
import 'package:work_os/services/global_methods.dart';
import 'package:work_os/widget/comment_widget.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String taskId;

  TaskDetailsScreen({required this.uploadedBy, required this.taskId});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _textStyle1 = TextStyle(
      color: Constant.textColor, fontSize: 15, fontWeight: FontWeight.normal);
  final _titleStyle = TextStyle(
      color: Constant.textColor, fontSize: 15, fontWeight: FontWeight.bold);
  TextEditingController _addCommentController = TextEditingController();
  bool _isComment = false;
  String? authorName;
  String? authorPosition;
  String? authorImageUrl;
  String? taskCategory;
  String? taskDescription;
  String? taskTitle;
  bool? _isDone;
  Timestamp? postDateTimeStamp;
  Timestamp? deadLineTimeStamp;
  String? postedDate;
  String? deadLineDate;
  bool isDeadLineAvailable = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getTaskDetails();
  }

  void getTaskDetails() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        authorPosition = userDoc.get('positionInCompany');
        authorImageUrl = userDoc.get('imageUrl');
      });
    }
    final DocumentSnapshot taskDataBase = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    if (taskDataBase == null) {
      return;
    }
    final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    if (taskDatabase == null) {
      return;
    } else {
      setState(() {
        taskTitle = taskDatabase.get('taskTitle');
        taskDescription = taskDatabase.get('taskDescription');
        _isDone = taskDatabase.get('isDone');
        postDateTimeStamp = taskDatabase.get('createdAt');
        deadLineTimeStamp = taskDatabase.get('deadLineDateTimeStamp');
        deadLineDate = taskDatabase.get('deadLineDate');
        var postDate = postDateTimeStamp!.toDate();
        postedDate = '${postDate.day}-${postDate.month}-${postDate.year}';
      });

      var date = deadLineTimeStamp!.toDate();
      isDeadLineAvailable = date.isAfter(DateTime.now());
    }
    // else {
    //   setState(() {
    //     taskTitle = taskDataBase.get('taskTitle');
    //     taskDescription = taskDataBase.get('taskDescription');
    //     _isDone = taskDataBase.get('isDone');
    //     postDateTimeStamp = taskDataBase.get('createdAt');
    //     deadLineTimeStamp = taskDataBase.get('deadLineDate');
    //     var postDate = postDateTimeStamp!.toDate();
    //     postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
    //   });
    //   var date = deadLineTimeStamp!.toDate();
    //   isDeadLineAvailable = date.isAfter(DateTime.now());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 24,
              color: Constant.textColor,
            ),
          ),
        ),
        backgroundColor: Constant.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              taskTitle == null ? '' : taskTitle!,
              style: TextStyle(
                  color: Constant.textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded by',
                            style: TextStyle(
                                color: Constant.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Constant.backgroundColor,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  authorImageUrl == null
                                      ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                      : authorImageUrl!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                authorName == null ? '' : authorName!,
                                style: _textStyle1,
                              ),
                              Text(
                                authorPosition == null ? '' : authorPosition!,
                                style: _textStyle1,
                              ),
                            ],
                          )
                        ],
                      ),
                      _dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded on:',
                            style: _titleStyle,
                          ),
                          Text(postedDate == null ? '' : postedDate!,
                              style: _titleStyle),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deadline date:',
                            style: _titleStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            deadLineDate == null ? '' : deadLineDate!,
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          _isDone == false
                              ? 'Deadline not finished yet'
                              : 'Deadline passed',
                          style: TextStyle(
                              color: _isDone == false
                                  ? Colors.green
                                  : Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      _dividerWidget(),
                      Text(
                        'Done state',
                        style: _titleStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              final User? _user = _auth.currentUser;
                              final _uid = _user!.uid;
                              if (_uid == widget.uploadedBy) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': true});
                                } catch (e) {
                                  GlobalMethod.showDialogError(
                                      error: 'Action can\'t be performed',
                                      ctx: context);
                                }
                              } else {
                                GlobalMethod.showDialogError(
                                    error:
                                        'Only uploader can change task state',
                                    ctx: context);
                              }
                              getTaskDetails();
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Constant.textColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          TextButton(
                            onPressed: () {
                              final User? _user = _auth.currentUser;
                              final _uid = _user!.uid;
                              if (_uid == widget.uploadedBy) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': false});
                                } catch (e) {
                                  GlobalMethod.showDialogError(
                                      error: 'Action can\'t be performed',
                                      ctx: context);
                                }
                              } else {
                                GlobalMethod.showDialogError(
                                    error:
                                        'Only uploader can change task state',
                                    ctx: context);
                              }
                              getTaskDetails();
                            },
                            child: Text(
                              'Not done',
                              style: TextStyle(
                                  color: Constant.textColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Opacity(
                              opacity: _isDone == false ? 1 : 0,
                              child: Icon(
                                Icons.check_box,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      _dividerWidget(),
                      Text(
                        'Task description',
                        style: _titleStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        taskDescription == null ? '' : taskDescription!,
                        style: _textStyle1,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: _isComment
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _addCommentController,
                                      style:
                                          TextStyle(color: Constant.textColor),
                                      maxLength: 200,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: MaterialButton(
                                            color: Colors.pink.shade700,
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            onPressed: () async {
                                              if (_addCommentController
                                                      .text.length <
                                                  5) {
                                                GlobalMethod.showDialogError(
                                                    error:
                                                        'Comment must be more than 5 character',
                                                    ctx: context);
                                              } else {
                                                final _generatedId =
                                                    Uuid().v4();
                                                await FirebaseFirestore.instance
                                                    .collection('tasks')
                                                    .doc(widget.taskId)
                                                    .update({
                                                  'taskComments':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'userId':
                                                          widget.uploadedBy,
                                                      'commentId': _generatedId,
                                                      'name': authorName,
                                                      'imageUrl':
                                                          authorImageUrl,
                                                      'commentBody':
                                                          _addCommentController
                                                              .text,
                                                      'time': Timestamp.now(),
                                                    }
                                                  ]),
                                                });
                                                await Fluttertoast.showToast(
                                                    msg:
                                                        "Your comment has been added",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Constant
                                                        .backgroundColor,
                                                    textColor:
                                                        Constant.textColor,
                                                    fontSize: 19.0);
                                                _addCommentController.clear();
                                              }
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'Post',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isComment = !_isComment;
                                              });
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.pink.shade900),
                                            ))
                                      ],
                                    ),
                                  ),
                                  // TextButton(
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         _isComment = !_isComment;
                                  //       });
                                  //     },
                                  //     child: Text(
                                  //       'Cancel',
                                  //       style: TextStyle(
                                  //           color: Colors.pink.shade900),
                                  //     ))
                                ],
                              )
                            : Center(
                                child: MaterialButton(
                                  color: Colors.pink.shade700,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  onPressed: () {
                                    setState(() {
                                      _isComment = !_isComment;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Text(
                                      'Add a Comment',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.data == null) {
                                return Center(
                                  child: Text(
                                    'No comment for this task',
                                    style: TextStyle(
                                        color: Constant.textColor,
                                        fontSize: 29,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }
                            return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => CommentWidget(
                                commentBody: snapshot.data!['taskComments']
                                    [index]['commentBody'],
                                commenterId: snapshot.data!['taskComments']
                                    [index]['userId'],
                                commenterImageUrl: snapshot
                                    .data!['taskComments'][index]['imageUrl'],
                                commenterName: snapshot.data!['taskComments']
                                    [index]['name'],
                                commentId: snapshot.data!['taskComments'][index]
                                    ['commentId'],
                              ),
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                );
                              },
                              itemCount: snapshot.data!['taskComments'].length,
                            );
                          })
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
// Widget _textInfo({required String text,required String text}){
//   return  Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         text,
//         style: TextStyle(
//             color: Constant.textColor,
//             fontSize: 15,
//             fontWeight: FontWeight.bold),
//       ),
//       Text(
//         text ,
//         style: TextStyle(
//             color: Constant.textColor,
//             fontSize: 15,
//             fontWeight: FontWeight.bold),
//       ),
//     ],
//   );
// }
}
