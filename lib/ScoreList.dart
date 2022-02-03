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
  final String token;
  ScoreList({Key? key, required this.parent_username, required this.student_id, required this.student_name, required this.operation, required this.token}) : super(key: key);
  @override
  _ScoreList createState() => _ScoreList();
}
class _ScoreList extends State<ScoreList> {
  bool refresh = true;
  List _items = [];
  String dropdownvalue = 'All';
  var items = ['All', 'Easy', 'Medium', 'Hard'];
  var postresponse;

  @override
  void initState() {
    // TODO: implement initState
    postItems();
    super.initState();
  }
   postItems()  async {
     String student_id = widget.student_id;
     String parent_username = widget.parent_username;
     String operation = widget.operation;
     if (dropdownvalue=='All') {
       print(dropdownvalue);
       postresponse = await post(
           Uri.http('uslsthesisapi.herokuapp.com', '/scorelist'),
           body: {
             'operation': operation,
             'student_id': student_id
           },
           headers: {
             "token":widget.token
       });
       print("test");
       if (postresponse.statusCode == 200) {
         var items = json.decode(postresponse.body);
         print("testsuccess");
         print(items);
           setState(() {
           refresh = false;
           _buildScoreList(context);
           _items = items;
         });
       }else {
         setState(() {
           _items = [];
           print("testfail");
         });
       }
     }else if(dropdownvalue=='Easy'||(dropdownvalue?.contains("Medium") ?? false) || (dropdownvalue?.contains("Hard") ?? false)){
       postresponse = await post(
           Uri.http('uslsthesisapi.herokuapp.com', '/scorelist/'+ dropdownvalue),
           body: {
             'operation': operation,
             'student_id': student_id
           },
          headers: {
             'token': widget.token
          }
       );
       print("test");
       if (postresponse.statusCode == 200) {
         var items = json.decode(postresponse.body);
         print("connectionsusccess");
         print(items);
         setState(() {
           refresh = false;
             print("test2");
             _buildScoreList(context);
             _items = items;

         });
       }else {
         setState(() {
           _items = [];
           print("connectionfailed");
         });
       }
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
          : _buildScoreList(context),
    );
  }
  Widget _buildScoreList(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height:20),
          Container(
            child: Text(
              widget.operation.toUpperCase(),
              style: TextStyle(
                shadows: [
                  Shadow(
                      color: Colors.black,
                      offset: Offset(0, -5))
                ],
                color: Colors.transparent,
                decoration:
                TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationThickness: 4,
                decorationStyle:
                TextDecorationStyle.dashed,
              ),
            ),
          ),
          SizedBox(height:20),
          /*Align(
                  child: Text("Difficulty: "),
              alignment: Alignment(0.75,-0.90),
    )*/
              Align(
                alignment: Alignment(0.90,-0.80),
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items:items.map((String items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                      );
                    }
                    ).toList(),
                    onChanged: (String? chosenValue){
                      setState(() {
                        dropdownvalue = chosenValue!;
                            postItems();
                      });
                    },
                    /*hint: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Select Difficulty",
                        style: TextStyle(color:Colors.grey),
                      )
                    )*/
                  ),
              ),
          _items.length > 0
              ? Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    dense: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget>[
                          Text(_items[index]["rawscore"].toString()+'/'+_items[index]["totalscore"].toString())
                        ]
                      ),
                      title: Text("Difficulty: "+ StringUtils.capitalize(_items[index][('difficulty')].toString().toUpperCase())),
                      subtitle: Text("Date: "+_items[index]["date"].toString()),
                    onTap: (){
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ScoreListDetails(parent_username:widget.parent_username,student_id:_items[index]["student_id"].toString(),student_name:_items[index]["student_name"].toString(), operation:_items[index]["operation"],id:_items[index]["id"].toString(),index: index.toString(),difficulty: _items[index]["difficulty"], token: widget.token,))
                        );
                      }
                    },
                  ),
                );
              },
            ),
          )
              : Container(
            width: double.infinity,
            height: 300,
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              child: Text(
                  "Empty!, Please Take a Test with this difficulty and operation to add into this list!",
              textAlign: TextAlign.center,)
            ),
          )
        ],
      ),
    );
  }
}

