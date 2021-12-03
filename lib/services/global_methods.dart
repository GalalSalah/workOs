import 'package:flutter/material.dart';
import 'package:work_os/constant/constant.dart';

class GlobalMethod{
  static  void showDialogError({required String error,required BuildContext ctx}) {
    showDialog(
        context: ctx,
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
                  child: Text('An error occurred'),
                )
              ],
            ),
            content: Text(
              error,
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
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
  static showPositionCompany(

      {required BuildContext context, required Size size, required Function onTap,}) {
    showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text(
                'Task Category',
                style: TextStyle(color: Constant.textColor),
              ),
              content: Container(
                width: size.width * 0.9,
                child: ListView.builder(
                    itemCount: Constant.jobsList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) =>
                        InkWell(
                          onTap: ()=>onTap(index),

                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Constant.backgroundColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Constant.jobsList[index],
                                  style: TextStyle(
                                      color: Constant.textColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child:  Text('Close',style: TextStyle(color: Constant.textColor),),
                ),
                TextButton(
                  onPressed: () {},
                  child:  Text('Cancel filter',style: TextStyle(color: Constant.textColor),),
                ),
              ],
            ));
  }


  static showTaskCategory(

      {required BuildContext context, required Size size,}) {
    showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text(
                'Task Category',
                style: TextStyle(color: Constant.textColor),
              ),
              content: Container(
                width: size.width * 0.9,
                child: ListView.builder(
                    itemCount: Constant.categoryListFilter.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) =>
                        InkWell(
                          onTap: (){},

                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Constant.backgroundColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Constant.categoryListFilter[index],
                                  style: TextStyle(
                                      color: Constant.textColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child:  Text('Close',style: TextStyle(color: Constant.textColor),),
                ),
                TextButton(
                  onPressed: () {},
                  child:  Text('Cancel filter',style: TextStyle(color: Constant.textColor),),
                ),
              ],
            ));
  }
}