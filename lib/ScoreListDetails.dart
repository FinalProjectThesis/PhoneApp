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
  ScoreListDetails({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.operation, required this.id}) : super(key: key);
  @override
  _ScoreListDetails createState() => _ScoreListDetails();
}
class _ScoreListDetails extends State<ScoreListDetails> {
  bool refresh = true;
  List _items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String id = widget.id;
    var postresponse = await post(
        Uri.http('uslsthesisapi.herokuapp.com', '/scorelistdetails'),
        body: {
          'id': id
        });
    if (postresponse.statusCode == 200) {
      var items = json.decode(postresponse.body);
      print(items);
      setState(() {
        refresh = false;
        _buildcontactlist(context);
        _items = items;
        print(_items);
      });
    } else{
      setState(() {
        _items = [];
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
        children: [
          _items.length > 0 ?
         Container(
           child: Text(_items[0]["student_name"]),
           )
        :Container()

        ],
      ),
    );
  }
}

