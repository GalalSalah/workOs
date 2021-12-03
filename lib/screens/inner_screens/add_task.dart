import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/services/global_methods.dart';
import 'package:work_os/widget/drawer_widget.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _taskCategoryController =
      TextEditingController(text: 'Choose category');
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDeadlineController =
      TextEditingController(text: 'Choose Deadline date');
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    _taskCategoryController.dispose();
    _taskDeadlineController.dispose();
    _taskDescriptionController.dispose();
    _taskTitleController.dispose();
    super.dispose();
  }

  void _uploadTask() async {
    final taskId = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_taskCategoryController.text == 'Choose category' ||
          _taskDeadlineController.text == 'Choose Deadline date') {
        GlobalMethod.showDialogError(
            error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
          'TaskId': taskId,
          'uploadedBy': _uid,
          'taskTitle': _taskTitleController.text,
          'taskDescription': _taskDescriptionController.text,
          'deadLineDate': _taskDeadlineController.text,
          'deadLineDateTimeStamp': deadLineDateTimeStamp,
          'taskCategory': _taskCategoryController.text,
          'taskComments': [],
          'createdAt': Timestamp.now(),
          'isDone': false,
        });
        await Fluttertoast.showToast(
            msg: "The task has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Constant.backgroundColor,
            textColor: Constant.textColor,
            fontSize: 19.0);
        _taskDescriptionController.clear();
        _taskTitleController.clear();
        setState(() {
          _taskDeadlineController.text = 'Choose Deadline date';
          _taskCategoryController.text = 'Choose category';
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constant.backgroundColor,
        iconTheme: IconThemeData(color: Constant.textColor),
      ),
      backgroundColor: Constant.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'All field are required',
                      style: TextStyle(
                        color: Constant.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleWidget(label: 'Task Category'),
                        _textFormFields(
                            controller: _taskCategoryController,
                            enable: false,
                            fct: () {
                              GlobalMethod.showTaskCategory(

                                  context: context, size: size);
                            },
                            maxLength: 100,
                            valueKey: 'TaskCategory'),
                        _titleWidget(label: 'Task title*'),
                        _textFormFields(
                            controller: _taskTitleController,
                            enable: true,
                            fct: () {},
                            maxLength: 100,
                            valueKey: 'TaskTitle'),
                        _titleWidget(label: 'Task description*'),
                        _textFormFields(
                            controller: _taskDescriptionController,
                            enable: true,
                            fct: () {},
                            maxLength: 1000,
                            valueKey: 'TaskDescription'),
                        _titleWidget(label: 'Task deadline date*'),
                        _textFormFields(
                            controller: _taskDeadlineController,
                            enable: false,
                            fct: () {
                              _pickDateDialog();
                            },
                            maxLength: 100,
                            valueKey: 'Taskdeadline'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : MaterialButton(
                            color: Constant.backgroundColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            onPressed: _uploadTask,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Upload Task',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.upload_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required Function fct,
    required bool enable,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'value is missing';
            } else {
              return null;
            }
          },
          // initialValue: 'hi',
          controller: controller,
          enabled: enable,
          key: ValueKey(valueKey),
          style:  TextStyle(
              color: Constant.textColor,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            // Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constant.backgroundColor),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constant.backgroundColor),
            ),
          ),
        ),
      ),
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _taskDeadlineController.text =
            '${picked!.day}-${picked!.month}-${picked!.year}';
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  Widget _titleWidget({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Constant.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
