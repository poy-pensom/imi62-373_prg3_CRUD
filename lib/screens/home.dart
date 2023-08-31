import 'package:flutter/material.dart';
import 'package:flutter_application_13/main.dart';
import 'package:flutter_application_13/models/config.dart';
import 'package:flutter_application_13/models/users.dart';
import 'package:flutter_application_13/screens/login.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl =
        "https://scontent-sin6-4.xx.fbcdn.net/v/t39.30808-6/363843858_3587999154778518_1099948911741066579_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeE5QfjerDCpn1YW5ZGsqiq8gGC945UdFziAYL3jlR0XOMfCOpyGPHSx1It7HjDR-urzd24JQT2nqYq0jB6M1-lj&_nc_ohc=tiaDiTyJflIAX94TBAo&_nc_ht=scontent-sin6-4.xx&oh=00_AfDbtIun0R8_U6KYYMOMVYXuROrnqYiKj2yKokNw9Lq0XA&oe=64F325FA";
    Users user = Configure.login;
    //print(user.toJson().toString()));
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
            leading: Icon(Icons.lock),
            title: Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, Login.routename);
            },
          )
        ],
      ),
    );
  }
}
