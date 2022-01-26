import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenList.dart';
import 'dart:convert';



class EditChild extends StatefulWidget {
  final String parent_username;
  final String student_name;
  final String student_age;
  final String student_id;
  EditChild({Key? key, required this.student_id, required this.parent_username, required this.student_name, required this.student_age,}) : super(key: key);
  @override
  _EditChild createState() => _EditChild();
}
class _EditChild extends State<EditChild> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _childnameController, _childageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _childnameController = TextEditingController(text: widget.student_name);
    _childageController = TextEditingController(text: widget.student_age);
  }
  EditChild() async {
    String studentname = _childnameController.text;
    String studentage = _childageController.text;
    var postresponse =
    await put(Uri.http(
        'uslsthesisapi.herokuapp.com', '/childedit/update' + widget.student_id),
        body: {
          "student_name": studentname,
          "student_age": studentage,
        });
    if (postresponse.statusCode == 200) {
      print("testsuccess");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChildrenList(parent_username: widget.parent_username),
        ),
            (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('Student ' + widget.student_name + ' Modified'),
                ],
              ),
            ),
          )
      );
    }else{
      print(postresponse.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text("Error in Modifying child"),
                ],
              ),
            ),
          )
      );
    }
  }
  showConfirmDeleteDialog(BuildContext context)  {
    // set up the buttons
    Widget CancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget ConfirmButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
        delete(Uri.http(
            'uslsthesisapi.herokuapp.com',
            '/childedit/delete/' + widget.student_id),
        );
      }
        );
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.deepOrange,
                content: Container(
                  height: 15,
                  child: Row(
                    children: [
                      Text('Student ' + widget.student_name + ' Deleted'),
                    ],
                  ),
                ),
              )
          );
        }
        );
        /*Navigator.push(context,MaterialPageRoute(builder: (context) => ContactList(token: widget.token,))).then((value) {
          setState(() {});
        });*/

    AlertDialog alert = AlertDialog(
      title: Text("Delete a Student"),
      content: Text("Are you sure you would want to delete this Student?"),
      actions: [
        CancelButton,
        ConfirmButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile of Student'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 30.0,
                color: Colors.red[900],
              ),
              onPressed: () {
                showConfirmDeleteDialog(context);
                /*http.delete(Uri.parse('https://contactsapptask.herokuapp.com/students/' + widget.id));
                Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp())).then((value) {
                  setState(() {});
                });*/
              },
            )
          ],
        ),
        body: buildRegisterScreen(context));
  }
  @override
  Widget buildRegisterScreen(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _childnameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Enter the Childs Name',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter your child's name";
                    }
                  }),
              TextFormField(
                  controller: _childageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter the Childs Age",
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Your child's name";
                    }
                  }),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                    child: Text(
                      'EDIT CHILD',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      EditChild();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}