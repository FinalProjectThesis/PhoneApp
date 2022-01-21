import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenListAdd.dart';
import 'package:thesis_mobile_app/ScoreListDetails.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/main.dart';


class ScoreList extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String operation;
  ScoreList({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.operation}) : super(key: key);
  @override
  _ScoreList createState() => _ScoreList();
}
class _ScoreList extends State<ScoreList> {
  bool refresh = true;
  List _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String student_id = widget.student_id;
    String parent_username = widget.parent_username;
    String operation = widget.operation;
    var postresponse = await post(
        Uri.http('uslsthesisapi.herokuapp.com', '/scorelist'),
        body: {
          'operation': operation,
          'student_id': student_id
        });
    var response = json.decode(postresponse.body);
    print("test");
    if (postresponse.statusCode == 200) {
      var items = json.decode(postresponse.body);
      print("testsuccess");
      print(items);
      setState(() {
        refresh = false;
        _buildcontactlist(context);
        _items = items;
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
        title: Text("Scores of " + widget.student_name),
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
          _items.length > 0
              ? Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget>[
                          Text(_items[index]["rawscore"].toString()+'/'+_items[index]["totalscore"].toString())
                        ]
                      ),
                      title: Text(StringUtils.capitalize("Difficulty: "+_items[index][('difficulty')].toString())),
                      subtitle: Text("Date: "+_items[index]["date"].toString()),
                    onTap: (){
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ScoreListDetails(parent_username:widget.parent_username,student_id:_items[index]["student_id"].toString(),student_name:_items[index]["student_name"].toString(), operation:_items[index]["operation"],id:_items[index]["id"].toString()))
                        );
                      }
                    },
                  ),
                );
              },
            ),
          )
              : Container()
        ],
      ),
    );
  }
}

