import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenListAdd.dart';
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
    print(response);
    if (postresponse.statusCode == 200) {
      var items = json.decode(postresponse.body);
      print("testsuccess");
      print(items);
      setState(() {
        refresh = false;
        _buildcontactlist(context);
        _items = items;
      });
    } else {
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
                      ),
                      leading: CircleAvatar(
                          backgroundColor: Colors.primaries[Random().nextInt(
                              Colors.primaries.length)],
                          child: Text(_items[index]['difficulty'])
                      ),
                      title: Text(_items[index]['difficulty'].toUpperCase()),
                      subtitle: Text(
                            _items[index]["rawscore"].toString() +
                              '/' +
                              _items[index]["totalscore"].toString())
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

