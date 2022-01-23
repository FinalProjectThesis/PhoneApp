import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class ScoreListDetails extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String operation;
  final String id;
  final String index;
  final String difficulty;
  ScoreListDetails({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.operation, required this.id, required this.index, required this.difficulty}) : super(key: key);
  @override
  _ScoreListDetails createState() => _ScoreListDetails();
}

class _ScoreListDetails extends State<ScoreListDetails> {
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
    String index = widget.index;
    print("index is " + index);
    String id = widget.id;
    postresponse = await post(
        Uri.http('uslsthesisapi.herokuapp.com', '/scorelist/' + widget.difficulty),
        body: {
          'operation': widget.operation,
          'student_id':widget.student_id,
        });
    RefreshScreen();
  }
  RefreshScreen() async{
    if (postresponse.statusCode == 200) {
      items = json.decode(postresponse.body);
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
        title: Text("Score Details"),
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
           child: Text("Student's Name : " + items[int.parse(widget.index)]["student_name"]
           )
         ),
          Container(
            child: Text("Test Taken in : " + items[int.parse(widget.index)]["date"].toString())
          ),
          Container(
              child: Text("Time  : " + items[int.parse(widget.index)]["time"].toString())
          ),
          Container(
            child: Text("Student's Score: " + items[int.parse(widget.index)]["rawscore"].toString() + "/" + items[0]["totalscore"].toString())
          ),
        ],
      ),
    );
  }
}

