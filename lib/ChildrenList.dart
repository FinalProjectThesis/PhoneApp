import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenListAdd.dart';
import 'package:thesis_mobile_app/OperationsGridView.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/ScoreList.dart';
import 'package:thesis_mobile_app/main.dart';
import 'package:thesis_mobile_app/EditUser.dart';


class ChildrenList extends StatefulWidget {
  final String parent_username;
  final String token;
  ChildrenList({Key? key, required this.parent_username, required this.token}) : super(key: key);
  @override
  _ChildrenList createState() => _ChildrenList();
}
class _ChildrenList extends State<ChildrenList> {
  bool refresh = true;
  List _items = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }
  fetchUser() async {
    String parent_username= widget.parent_username;
    var postresponse = await post(Uri.http('uslsthesisapi.herokuapp.com', '/childlist'),
        body: {
          'parent_username':parent_username
        },
      headers: {
          'token': widget.token
        }
        );
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
    } else{
      setState(() {
        _items = [];
        print("testfail");
      });
    }
  }


  DeleteChild() async{
    /*var deleteresponse = await delete(Uri.http('uslsthesisapi.herokuapp.com','/childlist/delete' +  id),
    fetchUser();*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Students'),
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
                          children:<Widget>[
                             IconButton(
                              icon:Icon(Icons.person),
                               onPressed:(){
                                 Navigator.push(context,MaterialPageRoute(builder: (context) => EditChild(parent_username:widget.parent_username,student_id:_items[index]["id"].toString(),student_name:_items[index]["student_name"].toString(), student_age: _items[index]["student_age"].toString(),token : widget.token))).then((value) => setState(() {
                                   fetchUser();
                                 }));
                               }
                            ),
                          ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[Random().nextInt(
                            Colors.primaries.length)],
                        child: Text(_items[index]['student_name'].substring(0,1).toUpperCase())
                      ),
                      title: Text(_items[index]['student_name']),
                      subtitle: Text("Student Age: " + _items[index]["student_age"].toString()),
                  onTap:(){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => OperationsGridView(parent_username:widget.parent_username,student_id:_items[index]["id"].toString(),student_name:_items[index]["student_name"].toString(),student_age:_items[index]["student_age"].toString(),token: widget.token, ))).then((value) => setState(() {
                      fetchUser();
                    }));
                    }
                  ),
                );
              },
            ),
          ) :Container(
            width: double.infinity,
            height: 300,
            alignment: Alignment.center,
            child: Container(
                width: 200,
                height: 200,
                child: Text(
                  "Please Add a Child! ",
                  textAlign: TextAlign.center,)
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text(
                  'Add A Child',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ChildrenListAdd(parent_username:widget.parent_username, token: widget.token))).then((value) => setState(() {
                    fetchUser();
                  }));
                }),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()))
                      .then((value) => setState(() {}));

                }),
            ),
        ],
      ),
    );
  }
}





