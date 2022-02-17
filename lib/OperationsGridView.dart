import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final String token;
  OperationsGridView({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.student_age, required this.token}) : super(key: key);
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
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Select an Operation'),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation:0,
        ),
        body: buildGridview(context),
    );
  }

  AdditionScoreList() async{
    String operation = 'addition';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation, token: widget.token,)));
  }
  SubtractionScoreList() async{
    String operation = 'subtraction';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation, token: widget.token)));
  }
  MultiplicationScoreList() async{
    String operation = 'multiplication';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation, token: widget.token)));
  }
  DivisionScoreList() async{
    String operation = 'division';
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScoreList(parent_username:widget.parent_username, student_id:widget.student_id, student_name:widget.student_name,operation:operation, token: widget.token)));
  }
  ProfileViewerScreen() async{
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserDetails(parent_username:widget.parent_username, student_id:widget.student_id, token: widget.token)));
  }

  @override
  Widget buildGridview(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:[Colors.purple,Colors.orange]
              )
          ),
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: SizedBox.expand(
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                          child:Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12.0)
                                )
                              ),
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
                                    SizedBox(height:10),
                                    Text("Addition",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ]
                              )
                          ),
                          onTap:(){
                           AdditionScoreList();
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                          child:Container(
                              decoration: BoxDecoration(
                                  color: Colors.tealAccent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12.0)
                                  )
                              ),
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
                                SizedBox(height:10),
                                Text("Subtraction",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold
                                ),
                                )
                              ]
                          )
                          ),
                              onTap:(){
                                SubtractionScoreList();
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0)
                              )
                            ),
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
                                SizedBox(height:10),
                                Text("Multiplication",
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ]
                            )
                          ),
                          onTap:(){
                            MultiplicationScoreList();
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                          child:Container(
                              decoration: BoxDecoration(
                                  color: Colors.purpleAccent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12.0)
                                  )
                              ),
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
                                    SizedBox(height:10),
                                    Text("Division",
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ]
                              )
                          ),
                          onTap:(){
                            DivisionScoreList();
                          }
                      ),
                    ),
                    ],
              ),
            ),
        ),
        ),
    );
  }
}


