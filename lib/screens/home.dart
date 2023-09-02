// import 'dart:ffi';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/config.dart';
import 'package:flutter_application_2/models/user.dart';
import 'package:flutter_application_2/screens/SideMenu.dart';
import 'package:flutter_application_2/screens/UserForm.dart';
import 'package:flutter_application_2/screens/UserInfo.dart';
import 'package:http/http.dart' as http;

   void main() {
    runApp(const Home());
   }

class Home extends StatefulWidget {
  static const routeName = "/";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();

   List<User> _usersList = [];
Future<void> getUsers() async{
  var url = Uri.http(Configure.server, "users");
  var resp = await http.get(url);
  setState(() {
        _usersList = userFromJson(resp.body);
        mainBody = showUsers();
  });
  return;
}
 @override
  void initState() {
    super.initState();
    User user = Configure.login;
    if(user.id != null){
      //mainBody = showUsers();
      getUsers();
    }
  }

   Widget showUsers(){
  return ListView.builder(
    itemCount: _usersList.length,
    itemBuilder: (context, index) {
      User user = _usersList[index];
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        child: Card(
          child: ListTile(
            title: Text("${user.fullname}"),
            subtitle: Text("${user.email}"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserInfo(),
              settings: RouteSettings(
                arguments: user  
          ))); 
            }, //to show info
            trailing: IconButton(
              onPressed: () async {
                String result = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserForm(),
                  settings: RouteSettings(
                    arguments: user 
            )
            ));
             if (result == "refresh"){
                    getUsers();
             }}, //to edit
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          onDismissed: (direction) { 
          removeUsers(user);
         }, // to delete
         background: Container(
          color: Colors.red,
          margin: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.white),
         ),
        );
    },);
   }

    Future<void> removeUsers(user) async{
      var url = Uri.http(Configure.server, "user/${user.id}");
      var resp = await http.delete(url);
      print(resp.body);
      return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      drawer: SideMenu(),
      body: mainBody,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          String result = await Navigator.push(
            context,MaterialPageRoute(
               builder: (context) => UserForm(),));
          if ( result == "refresh" ) {
            getUsers();
        }
      },
        child: const Icon(Icons.person_add_alt_1),
        ),
      );
  }
}
  
 