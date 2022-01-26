import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thesis_mobile_app/UserDetails.dart';
import './ScoreList.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenListAdd.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/ScoreList.dart';
import 'package:thesis_mobile_app/main.dart';


class OperationsGridView extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String student_age;
  OperationsGridView({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.student_age}) : super(key: key);
  @override
  _OperationsGridView createState() => _OperationsGridView();
}
class _OperationsGridView extends State<OperationsGridView> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select an Operation'),
        ),
        body: buildGridview(context),
    );
  }

  AdditionScoreList() async{
    String operation = 'addition';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation)));
  }
  SubtractionScoreList() async{
    String operation = 'subtraction';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation)));
  }
  MultiplicationScoreList() async{
    String operation = 'multiplication';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation)));
  }
  DivisionScoreList() async{
    String operation = 'division';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation)));
  }
  ProfileViewerScreen() async{
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserDetails(parent_username:widget.parent_username, student_id:widget.student_id)));
  }

  @override
  Widget buildGridview(BuildContext context) {
    return Scaffold(
        body: Container(
            child: GridView(
              children: [
                InkWell(
                    child:Container(
                        color: Colors.orange,
                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              CircleAvatar(
                                backgroundColor: Colors.primaries[Random().nextInt(
                                    Colors.primaries.length)],
                                child: Icon(
                                    Icons.add,
                                    size: 70
                                ),
                                radius:40,
                              ),
                            ]
                        )
                    ),
                    onTap:(){
                     AdditionScoreList();
                    }
                ),
                InkWell(
                    child:Container(
                      color: Colors.red,
                        child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          CircleAvatar(
                            backgroundColor: Colors.primaries[Random().nextInt(
                                Colors.primaries.length)],
                            child: Icon(
                                Icons.remove,
                                size: 70
                            ),
                            radius:40,
                          ),
                        ]
                    )
                    ),
                        onTap:(){
                          SubtractionScoreList();
                    }
                ),
                InkWell(
                    child:Container(
                      color: Colors.green,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          CircleAvatar(
                              backgroundColor: Colors.primaries[Random().nextInt(
                                  Colors.primaries.length)],
                              child: Icon(
                                Icons.close,
                                size: 70
                              ),
                              radius:40,
                          ),
                        ]
                      )
                    ),
                    onTap:(){
                      MultiplicationScoreList();
                    }
                ),
                InkWell(
                    child:Container(
                    color: Colors.blue,
                        child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              CircleAvatar(
                                backgroundColor: Colors.primaries[Random().nextInt(
                                    Colors.primaries.length)],
                                child: Icon(
                                  CupertinoIcons.divide,
                                  size: 50,
                                ),
                                radius:40,
                              ),
                            ]
                        )
                    ),
                    onTap:(){
                      DivisionScoreList();
                    }
                ),
                InkWell(
                  child:Container(
                    child: Text("Profile"),
                        color: Colors.white10,
                  ),
                    onTap:(){
                      ProfileViewerScreen();
                  }
                ),
                InkWell(
                    child:Container(
                        child: Text("xd"),
                      color: Colors.pink,
                    ),
                    onTap:(){
                      ProfileViewerScreen();
                    }
                )
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),

            )
        ),

    );
  }
}


