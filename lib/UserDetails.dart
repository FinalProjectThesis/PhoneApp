import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class UserDetails extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String token;
  UserDetails({Key? key, required this.parent_username, required this.student_id, required this.token}) : super(key: key);

  @override
  _UserDetails createState() => _UserDetails();
}
class _UserDetails extends State<UserDetails> {
  bool refresh = true;
  var items = [];
  var postresponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String username = widget.parent_username;
    print(username);
    postresponse = await post(
        Uri.http('uslsthesisapi.herokuapp.com', '/userdetails'),
        body: {
          'username': username
        },
        headers: {
          "token": widget.token
    });
    RefreshScreen();
  }

  RefreshScreen() async{
    if (postresponse.statusCode == 200) {
      items = json.decode(postresponse.body);
      var itemChart = json.decode(postresponse.body);
      setState(() {
        print (items);
        refresh = false;
        _buildcontactlist(context);
      });
    } else{
      setState(() {
        print("testfail");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Account Details"),
      ),
      //if Refresh = false then load circular progress indicator, else load _buildcontactlist widget
      body: refresh ? Center(
          child: CircularProgressIndicator()
      )
          : _buildcontactlist(context),
    );
  }
  /*Widget _buildemptylistmessage(BuildContext context) {
    return Scaffold(
      body: Column(
        children:<Widget>[
          Container(
            child: Text("Empty, Please Do Tests in This Subject to Recieve Entries")
          )
        ]
      ),
    );
  }*/
  Widget _buildcontactlist(BuildContext context) {
    return Scaffold(
        body: Column(
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(height: 30,),
            Container(
                child: Text("Your Username : " + items[0]["username"]
                )
            ),
            Container(
                child: Text("Your First Name : " + items[0]["first_name"].toString()
                )
            ),
            Container(
                child: Text("Your Last Name : " + items[0]["last_name"].toString()
                )
            ),
          ],
        )
    );
  }
}