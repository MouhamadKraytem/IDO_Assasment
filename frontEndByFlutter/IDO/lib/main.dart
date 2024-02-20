import 'package:flutter/material.dart';
import 'package:ido/ToDoList.dart';
import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Future<Widget> getPage() async {
    String id = await token.getString("id");
    if (id == null || id.isEmpty) {
      // return AdminPage();
      return LoginPage();
    } else {
      return ToDoList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IDO PROJECT",
      home: LoginPage(),
    );
  }
}
