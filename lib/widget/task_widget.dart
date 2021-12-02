import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/screens/inner_screens/task_details.dart';
import 'package:work_os/services/global_methods.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle;
  final String taskDescription;
  final String taskId;
  final String uploadedBy;
  final bool isDone;

  TaskWidget(
      {required this.isDone,
      required this.taskDescription,
      required this.taskId,
      required this.taskTitle,
      required this.uploadedBy});

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        onTap: () {
          _navigateToTaskDetails(context);
        },
        onLongPress: _deleteTask,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.isDone
                ? 'https://image.flaticon.com/icons/png/128/390/390973.png'
                : 'https://image.flaticon.com/icons/png/128/850/850960.png'),
          ),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Constant.textColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale_outlined,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              style: TextStyle(fontSize: 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }

  void _navigateToTaskDetails(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          uploadedBy: widget.uploadedBy,
          taskId: widget.taskId,
        ),
      ),
    );
  }

  _deleteTask() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        if (widget.uploadedBy == _uid) {
                          await FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .delete();
                          await Fluttertoast.showToast(
                              msg: "Task has been deleted",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Constant.backgroundColor,
                              textColor: Constant.textColor,
                              fontSize: 19.0);
                          Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                        } else {
                          GlobalMethod.showDialogError(
                              error: 'You can\'t delete this task', ctx: ctx);
                        }
                      } catch (e) {
                        GlobalMethod.showDialogError(
                            error: 'This task can\'t be deleted', ctx: context);
                      } finally {}
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ))
              ],
            ));
  }
}
