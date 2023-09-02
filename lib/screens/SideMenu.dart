import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/config.dart';
import 'package:flutter_application_2/screens/login.dart';
import 'package:flutter_application_2/screens/home.dart';
import 'package:flutter_application_2/models/user.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl = 
        "https://i.pinimg.com/564x/a8/12/05/a81205f3f1116ae4009000a0534bc2a3.jpg";

    User user = Configure.login;
    //print(user.toJson().toString());
   if (user.id != null) {
     accountName = user.fullname!;
     accountEmail = user.email!;
  }
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
              ),
              ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          ),
        ],
      ),
    );
  }
}


