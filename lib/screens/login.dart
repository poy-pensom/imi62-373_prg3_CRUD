import 'package:flutter_application_13/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_13/models/config.dart';
import 'package:flutter_application_13/models/users.dart';

class Login extends StatefulWidget {
  static const routename = "/login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();

  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(Configure.server, "users", params);
    var resp = await http.get(url);
    print(resp.body);
    List<Users> login_result = usersFromJson(resp.body);
    print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("username or password invalid")));
    } else {
      Configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textHeader(),
                emailInputField(),
                passwordInputfield(),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SubmitButton(),
                    SizedBox(
                      width: 10.0,
                    ),
                    BackButton(),
                    SizedBox(
                      width: 10.0,
                    ),
                    registerLink()
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: "Pensom Ponchai",
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
    return TextFormField(
      initialValue: "pensom@mail.com",
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

  Widget passwordInputfield() {
    return TextFormField(
      initialValue: "123456",
      obscureText: true,
      decoration:
          InputDecoration(labelText: "Password:", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget SubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          login(user);
        }
      },
      child: Text("Login"),
    );
  }

  Widget textHeader() {
    return AppBar(
      title: Center(child: Text("Login")), // หัวข้อที่คุณต้องการแสดง
    );
  }

  Widget BackButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Back"),
    );
  }

  Widget registerLink() {
    return InkWell(
      child: const Text("Sign Up"),
      onTap: () {},
    );
  }
}
