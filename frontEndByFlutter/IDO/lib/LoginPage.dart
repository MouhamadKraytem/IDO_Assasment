import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ido/User.dart';
import 'package:ido/ToDoList.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'User.dart' as User;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

EncryptedSharedPreferences token = EncryptedSharedPreferences();

class _LoginPageState extends State<LoginPage> {




  List<User.User> users = [
    User.User("moohamadkraytem15@gmail.com", "aaa", "assets/Bitmap.png"),
    User.User("gameryuri144@gmail.com", "123", "assets/Bitmap.png"),
  ];
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  void Login() async {
    var url = "https://localhost:7225/UserApi/login";
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body:
            convert.jsonEncode({'Email': _email.text, 'Password': _pass.text}));

    if (res.statusCode == 200) {
      var red = convert.jsonDecode(res.body);
      print(red);
      if (red['status'] == "success") {
        token.setString("id", red['user']['id'].toString());
        token.setString("email", red['user']['email']);
        token.setString("img", red['user']['img']);
        print(await token.getString("id"));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "login sucesss / on update items press enter when complete editing")));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ToDoList();
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalide email or passowrd")));
      }
    } else {
      print(res.body);
      print("connection error");
    }
  }

  // void login(String email, String pass) {
  //   bool b = true;
  //   for (int i = 0; i < users.length; i++) {
  //     if (users[i].email == email && users[i].pass == pass) {
  //       b = false;
  //
  //       token.setString("email", email);
  //       token.setString("img", users[i].img);
  //       _email.text = "";
  //       _pass.text = "";
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //         return ToDoList();
  //       }));
  //     }
  //   }
  //   if (b) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Wrong email or pass")));
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Color(0xFF262626),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/logo.png",
                    width: 350,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/woman.svg",
                      width: 200,
                      height: 200,
                    ),
                    SvgPicture.asset(
                      "assets/man.svg",
                      width: 200,
                      height: 200,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF8556A4), Color(0xFF212529)],
                // Optional: Specify stops for each color
                // stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Time To Work",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.0,
                        fontFamily: "HelveticaNeue"),
                  ),
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 500,
                              decoration: BoxDecoration(
                                color: Color(0xFF222222),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  validator: (String? value) {
                                    bool isValidEmail = RegExp(
                                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                        .hasMatch(value!);

                                    if (!isValidEmail) {
                                      return 'Please enter a valid email address';
                                    } else if (value == null || value.isEmpty) {
                                      return "empty field";
                                    }
                                    // You can add more complex validation logic here if needed.
                                    return null;
                                  },
                                  controller: _email,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    // Add background
                                    fillColor: Color(0xFF222222),
                                    // Background color
                                    labelText: "enter your email",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                    border: InputBorder
                                        .none, // Remove default border
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              width: 500,
                              decoration: BoxDecoration(
                                color: Color(0xFF222222),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "empty field";
                                    }
                                    // You can add more complex validation logic here if needed.
                                    return null;
                                  },
                                  obscuringCharacter: '*',
                                  obscureText: true,
                                  controller: _pass,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: "enter your pass",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                    filled: true,
                                    // Add background
                                    fillColor: Color(0xFF222222),
                                    // Background color

                                    border: InputBorder
                                        .none, // Remove default border
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              width: 500,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    Login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFb6a3c2),
                                  // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFF403564), // Text color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
