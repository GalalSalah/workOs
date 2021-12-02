import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os/constant/constant.dart';
import 'package:work_os/screens/inner_screens/profile.dart';

class AllWorkerWidget extends StatefulWidget {
  late final String userID;
  late final String userName;
  late final String userEmail;
  late final String positionInCompany;
  late final String phoneNumber;
  late final String userImageUrl;

  AllWorkerWidget(
      {required this.userID,
      required this.phoneNumber,
      required this.userName,
      required this.userEmail,
      required this.userImageUrl,
      required this.positionInCompany});

  @override
  _AllWorkerWidgetState createState() => _AllWorkerWidgetState();
}

class _AllWorkerWidgetState extends State<AllWorkerWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userID,)));
          },
          // onLongPress: _deleteTask,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: CircleAvatar(

              backgroundColor: Colors.transparent,
              radius: 20,
              child: Image.network(widget.userImageUrl == null
                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                  : widget.userImageUrl),
            ),
          ),
          title: Text(
            widget.userName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Constant.textColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.linear_scale_outlined,
                color: Colors.pink.shade800,
              ),
               Text(
                '${widget.positionInCompany} / ${widget.phoneNumber}',
                style: TextStyle(fontSize: 20),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: _mailTo,
            icon: Icon(
              Icons.mail_outline,
              color: Colors.pink.shade800,
            ),
          )),
    );
  }
  void _mailTo() async {
    var mailUrl = 'mailto:${widget.userEmail}';

    await launch(mailUrl);

  }
}
