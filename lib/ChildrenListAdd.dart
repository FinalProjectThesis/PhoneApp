import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:thesis_mobile_app/ChildrenList.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/main.dart';

class ChildrenListAdd extends StatefulWidget {
  final String parent_username;
  final String token;

  ChildrenListAdd(
      {Key? key, required this.parent_username, required this.token})
      : super(key: key);

  @override
  _ChildrenListAdd createState() => _ChildrenListAdd();
}

class _ChildrenListAdd extends State<ChildrenListAdd> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _childnameController, _childageController;
  bool isLoading = false;

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
    String parent_username = widget.parent_username;
    try {
      var postresponse = await post(
        Uri.http('uslsthesisapi.herokuapp.com', '/childadd'),
        body: {
          "student_name": studentname,
          "student_age": studentage,
          "parent_username": parent_username
        },
        headers: {"token": widget.token},
      ).timeout(const Duration(seconds: 10));
      if (postresponse.statusCode == 200) {
        var response = json.decode(postresponse.body);
        if (response == "Success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Container(
                height: 15,
                child: Row(
                  children: [
                    Text('Child Added to User'),
                  ],
                ),
              ),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ChildrenList(
                  parent_username: parent_username, token: widget.token),
            ),
            (route) => false,
          );
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
          setState(() {
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text('Error'),
              ],
            ),
          ),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('API Error, Please Check Internet Connection'),
            ],
          ),
        ),
      ));
      setState(() {
        isLoading = false;
      });
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('API Error, Please Check Internet Connection'),
            ],
          ),
        ),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Add a student'),
          ),
          body: buildRegisterScreen(context)),
    );
  }

  @override
  Widget buildRegisterScreen(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.orange])),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: _childnameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Enter the Childs Name',
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              size: 30,
                            ),
                            contentPadding: EdgeInsets.all(15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Username';
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: _childageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter the Childs Age",
                            prefixIcon: Icon(
                              Icons.tag,
                              size: 30,
                            ),
                            contentPadding: EdgeInsets.all(15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Password';
                            }
                          }),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                shape: StadiumBorder(),
                                onSurface: Colors.indigo),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white)),
                                      const SizedBox(width: 24),
                                      Text("Please Wait....",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  )
                                : Text(
                                    'Add Student',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            onPressed: !isLoading
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      AddChild();
                                      if (isLoading == false)
                                        return setState(() => isLoading = true);
                                    }
                                  }
                                : null),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
