import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        snackBarTheme:
        SnackBarThemeData(
          actionTextColor: Colors.black12,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title:'Contacts Application with Flutter',
      home:LoginScreen(),
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  ConfirmLogin()async{
    String username= _usernameController.text;
    String userpassword= _passwordController.text;
    var postresponse = await post(Uri.http('uslsthesisapi.herokuapp.com', '/login'),
        body: {
          'username': username,
          'password': userpassword
        });
    var response = json.decode(postresponse.body);
    print(response);
    if (response == "Succeeded"){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('Login Succeeded'),
                ],
              ),
            ),
          )
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: [
                  Text('Wrong Username or Password'),
                ],
              ),
            ),
          )
      );
    }
  }
  RegisterScreenButton()async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterRoute())
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: buildLoginScreen(context)
    );
  }
  @override
  Widget buildLoginScreen (BuildContext context) {
    return Container(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Enter your Username',
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
                  }
              ),
              TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter the Password',
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
                      return 'Please enter Your Password';
                    }
                  }
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(child: Text('LOGIN', style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),),
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        ConfirmLogin();
                      }
                    }
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(child: Text('REGISTER HERE', style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),),
                    onPressed: () {
                        RegisterScreenButton();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRoute createState()=> _RegisterRoute();
}
  class _RegisterRoute extends State<RegisterRoute> {
    final _formKey = GlobalKey<FormState>(); // For Storing Form state
    late TextEditingController _passwordController, _usernameController,_firstnameController,_lastnameController;
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _passwordController = TextEditingController();
      _usernameController = TextEditingController();
      _firstnameController = TextEditingController();
      _lastnameController = TextEditingController();
    }
    RegisterUser() async{
      String username= _usernameController.text;
      String userpassword= _passwordController.text;
      String userfirstname= _firstnameController.text;
      String userlastname = _lastnameController.text;
      var postresponse = await post(Uri.http('uslsthesisapi.herokuapp.com', '/register'),
          body: {
            'username': username,
            'password': userpassword,
            'first_name':userfirstname,
            'last_name': userlastname
          });
      var response = json.decode(postresponse.body);
      if (response == "SameUsername"){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.deepOrange,
              content: Container(
                height: 15,
                child: Row(
                  children: [
                    Text('Another User has the Same Username'),
                  ],
                ),
              ),
            )
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.lightGreen,
              content: Container(
                height: 15,
                child: Row(
                  children: [
                    Text('User has been created'),
                  ],
                ),
              ),
            )
        );
        Navigator.pop(context);
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
        body: buildRegisterScreen(context)
    );
  }
  @override
  Widget buildRegisterScreen (BuildContext context) {
    return Container(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Enter your Username',
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
                  }
              ),
              TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter the Password',
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
                      return 'Please enter Your Password';
                    }
                  }
              ),
              TextFormField(
                  controller: _firstnameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Enter your First Name ',
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
                      return 'Please Enter your First Name';
                    }
                  }
              ),
              TextFormField(
                  controller: _lastnameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Enter your Last Name',
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
                      return 'Please enter your Last Name';
                    }
                  }
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(child: Text('REGISTER USER ', style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),),
                    onPressed: () {
                        RegisterUser();
                    }
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(child: Text('BACK', style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}