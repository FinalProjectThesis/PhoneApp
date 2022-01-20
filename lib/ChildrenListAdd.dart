import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenList.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/main.dart';


class ChildrenListAdd extends StatefulWidget {
  final String parent_username;
  ChildrenListAdd({Key? key, required this.parent_username}) : super(key: key);
  @override
  _ChildrenListAdd createState() => _ChildrenListAdd();
}
class _ChildrenListAdd extends State<ChildrenListAdd> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _childnameController, _childageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _childnameController = TextEditingController();
    _childageController = TextEditingController();
  }
  AddChild() async {
    String studentname = _childnameController.text;
    String studentage = _childageController.text;
    var postresponse =
    await post(Uri.http('uslsthesisapi.herokuapp.com', '/childadd'), body: {
      "student_name": studentname,
      "student_age": studentage,
      "parent_username": widget.parent_username
    });
    var response = json.decode(postresponse.body);
    if (response == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text('Successfully Added Student!'),
              ],
            ),
          ),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChildrenList(parent_username: widget.parent_username,)))
          .then((value) => setState(() {}));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightGreen,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('There is an Error.'),
            ],
          ),
        ),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a Child'),
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
                      return 'Please enter Your Username';
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
                      'ADD CHILD',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      AddChild();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}