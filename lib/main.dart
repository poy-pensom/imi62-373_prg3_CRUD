import 'package:flutter/material.dart';
import 'package:flutter_application_13/models/config.dart';
import 'package:flutter_application_13/models/users.dart';
import 'package:flutter_application_13/screens/login.dart';
import 'package:flutter_application_13/screens/user_form.dart';
import 'package:flutter_application_13/screens/user_info.dart';
import 'screens/home.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users CRUD',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
      },
    );
  }
}

class Home extends StatefulWidget {
  static const routeName = "/";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();

  Widget showUsers() {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        Users user = _userList[index];
        return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            child: Card(
              child: ListTile(
                title: Text("${user.fullname}"),
                subtitle: Text("${user.email}"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInfo(),
                          settings: RouteSettings(arguments: user)));
                },
                trailing: IconButton(
                  onPressed: () async {
                    String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserForm(),
                            settings: RouteSettings(arguments: user)));
                    if (result == "refresh") {
                      getUsers();
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ),
            onDismissed: (direction) {
              removeUsers(user);
            }, //to be delete
            background: Container(
              color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Users user = Configure.login;
    if (user.id != null) {
      getUsers();
    }
  }

  List<Users> _userList = [];
  Future<void> getUsers() async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.get(url);
    setState(() {
      _userList = usersFromJson(resp.body);
      mainBody = showUsers();
    });
  }

  Future<void> removeUsers(user) async {
    var url = Uri.http(Configure.server, "users/${user.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const SideMenu(),
      body: mainBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserForm()));
          if (result == "refresh") {
            getUsers();
          }
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}
