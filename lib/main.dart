
import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:thesis_mobile_app/ChildrenList.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.black12,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Contacts Application with Flutter',
      home: Scaffold(
        body: LoginScreen()
      )
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // For Storing Form state
  late TextEditingController _passwordController, _usernameController;
  bool isLoading = false;
  bool _showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  ConfirmLogin() async {
    String username = _usernameController.text;
    String userpassword = _passwordController.text;
    try {
      var postresponse = await post(
          Uri.http('uslsthesisapi.herokuapp.com', '/login'),
          body: {'username': username, 'password': userpassword}).
      timeout(const Duration(seconds: 5));
      var response = json.decode(postresponse.body);
      if (postresponse.statusCode == 200) {
        if (response == "Failed") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('Wrong Username or Password'),
                ],
              ),
            ),
          ));
          setState(() {
            isLoading = false;
          });
        }
        else if (response == 'No such User') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('No such username exists'),
                ],
              ),
            ),
          ));
          setState(() {
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('Login Succeeded'),
                ],
              ),
            ),
          ));
          String parent_username = username;
          /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChildrenList(parent_username: parent_username)))
          .then((value) => setState(() {}));*/
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChildrenList(
                      parent_username: parent_username, token: response),
            ),
                (route) => false,
          ).then((value) {
            setState(() {});
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
      }
    }on TimeoutException catch(_){
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
  RegisterScreenButton() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: buildLoginScreen(context)),
    );

  }

  @override
  Widget buildLoginScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:[Colors.purple,Colors.orange]
            )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(height:20),
                        Image.asset('assets/images/keys.png',
                        height: 170,
                        width: 300),
                        SizedBox(height:10),
                      ],
                    ),
                    SizedBox(height:10),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                              TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                  size: 30,
                                ),
                                contentPadding: EdgeInsets.all(15),
                                hintText: "Enter Username"
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Your Username';
                                  }
                                }
                              ),
                      TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.tag,
                              size: 30,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(15),
                              hintText: "Enter Password"
                          ),
                          obscureText: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Password';
                            }
                          }
                          ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: StadiumBorder(),
                              onSurface: Colors.indigo
                            ),
                            child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width:20, height:20, child:CircularProgressIndicator(color:Colors.white)),
                                const SizedBox(width:24),
                                Text("Please Wait....",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ))
                              ],
                            )
                            :Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: !isLoading ? () async {
                              if (_formKey.currentState!.validate()) {
                                ConfirmLogin();
                              if (isLoading==false) return
                                setState(() => isLoading = true);
                                }
                              }
                              :null
                            ),
                      ),
                      Container(
                          child: Column(
                            children: [
                              Divider(
                                thickness: 1, // thickness of the line
                                indent: 20, // empty space to the leading edge of divider.
                                endIndent: 20, // empty space to the trailing edge of the divider.
                                color: Colors.black, // The color to use when painting the line.
                                height: 15, // The divider's height extent.
                              ),
                              Text("Don't have an account?",
                                  style: TextStyle(fontSize: 15)
                              )
                            ],
                          )
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                            onPressed: () {
                              RegisterScreenButton();
                              },
                            ),
                      ),
                      SizedBox(height:30)
                  ],
                ),
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

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRoute createState() => _RegisterRoute();
}

class _RegisterRoute extends State<RegisterRoute> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;// For Storing Form state
  late TextEditingController _passwordController,
      _usernameController,
      _firstnameController,
      _lastnameController,
      _ConfirmpasswordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _ConfirmpasswordController = TextEditingController();
  }

  RegisterUser() async {
    String username = _usernameController.text;
    String userpassword = _passwordController.text;
    String userfirstname = _firstnameController.text;
    String userlastname = _lastnameController.text;
    String confirmpassword = _ConfirmpasswordController.text;
    var postresponse =
    await post(Uri.http('uslsthesisapi.herokuapp.com', '/register'), body: {
      'username': username,
      'password': userpassword,
      'first_name': userfirstname,
      'last_name': userlastname
    });
    var response = json.decode(postresponse.body);
    if (postresponse.statusCode==200){
    if (response == "SameUsername") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('Another User has the Same Username'),
            ],
          ),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightGreen,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('User has been created'),
            ],
          ),
        ),
      ));
      String parent_username = username;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChildSetup(parent_username: parent_username)))
          .then((value) => setState(() {}));
      }
    }else{
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
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                  colors:[Colors.purple,Colors.orange]
              )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text("Sign Up",
                          style: GoogleFonts.openSans(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            size: 30,
                          ),
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Enter Username"
                      ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Username';
                            }
                          }),
                      TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter the Password',
                            prefixIcon: Icon(
                              Icons.tag,
                              size: 30,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(15),
                          ),
                          obscureText: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Password';
                              }
                            }
                          ),
                      TextFormField(
                          controller: _ConfirmpasswordController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Confirm your Password',
                            prefixIcon: Icon(
                              Icons.tag,
                              size: 30,
                            ),
                            contentPadding: EdgeInsets.all(15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Your Password';
                            }else if (_ConfirmpasswordController != _passwordController){
                              return 'Please Type the same Password you entered earlier!';
                            }
                          }
                      ),
                      TextFormField(
                          controller: _firstnameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Enter your First Name ',
                            contentPadding: EdgeInsets.all(15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your First Name';
                              }
                            }
                          ),
                      TextFormField(
                          controller: _lastnameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Enter your Last Name',
                            contentPadding: EdgeInsets.all(15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Last Name';
                              }
                            }
                          ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'PROCEED',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                RegisterUser();
                              }
                            }),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'BACK TO LOGIN',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChildSetup extends StatefulWidget {
  final String parent_username;

  ChildSetup({Key? key, required this.parent_username}) : super(key: key);

  @override
  _ChildSetup createState() => _ChildSetup();
}

class _ChildSetup extends State<ChildSetup> {
  final _formKey = GlobalKey<FormState>(); // For Storing Form state
  late TextEditingController _childnameController, _childageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _childnameController = TextEditingController();
    _childageController = TextEditingController();
  }

  RegisterUser() async {
    String studentname = _childnameController.text;
    String studentage = _childageController.text;
    String parent_username = widget.parent_username;
    var postresponse =
    await post(Uri.http('uslsthesisapi.herokuapp.com', '/childadd'), body: {
      "student_name": studentname,
      "student_age": studentage,
      "parent_username": parent_username
    });
    if (postresponse.statusCode==200){
    var response = json.decode(postresponse.body);
    if (response == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text('User Successfully Registered With Child!'),
              ],
            ),
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
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
      }
    }else{
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
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Child to Said Parent'),
          ),
          body: buildRegisterScreen(context)),
    );
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
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Username';
                    }
                  }
                  ),
              TextFormField(
                  controller: _childageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter the Childs Age",
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Password';
                    }
                  }),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      'REGISTER USER',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      RegisterUser();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
