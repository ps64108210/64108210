import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/config.dart';
import 'package:flutter_application_2/models/user.dart';
import 'package:flutter_application_2/screens/home.dart';
//import 'package:flutter_application_2/screens/login.dart';
import 'package:http/http.dart' as http;

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  //Users user = Users();
  late User user;

  //get http => null;

  Future<void> addNewUser(user) async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = userFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> updateData(user) async {
    var url = Uri.http(Configure.server, "users/${user.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = userFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as User;
      print(user.fullname);
    } catch (e) {
      user = User();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Form"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              genderFormInput(),
              SizedBox(
                height: 10,
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }
  
  
Widget fnameInputField() {
  //var user;
  return TextFormField(
    initialValue: user.fullname,
    decoration:
        InputDecoration(labelText: "Fullname:", icon: Icon(Icons.person)),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      return null;
    },
    onSaved: (newValue) => user.fullname = newValue,
  );
  
}

Widget emailInputField() {
  //var user;
  return TextFormField(
    initialValue: user.email,
    decoration: InputDecoration(labelText: "Email:", icon: Icon(Icons.email)),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      if (!EmailValidator.validate(value)) {
        return "It is not email format";
      }
      return null;
    },
    onSaved: (newValue) => user.email = newValue,
  );
}

Widget passwordInputField() {
  //var user;
  return TextFormField(
    obscureText: true,
    initialValue: user.password,
    decoration: InputDecoration(labelText: "Password:", icon: Icon(Icons.lock)),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      return null;
    },
    onSaved: (newValue) => user.password = newValue,
  );
}

Widget genderFormInput() {
  var initGen = user.gender ?? "None";
  return DropdownButtonFormField(
    value: initGen,
    decoration: InputDecoration(labelText: "Gender:", icon: Icon(Icons.man)),
    items: Configure.gender.map((String val) {
      return DropdownMenuItem(
        value: val,
        child: Text(val),
      );
    }).toList(),
    onChanged: (value) {
      user.gender = value;
    },
    onSaved: (newValue) => user.gender = newValue,
  );
}

Widget submitButton(){
    return ElevatedButton(onPressed: () async {
      if (_formkey.currentState!.validate()){
        _formkey.currentState!.save();
        print(user.toJson().toString());
        if(user.id == null){
          await addNewUser(user);
        }else{
          await updateData(user);
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home(),
        ));
      }
    },
     child: Text("Save"));
  }

}
