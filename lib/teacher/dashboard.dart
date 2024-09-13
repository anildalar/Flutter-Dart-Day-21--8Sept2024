//1 Impaorta
import 'package:flutter/material.dart';

//2. Entrypoint

import 'package:flutter/cupertino.dart';

void main() {
  var ceo = new TeacherDashboard();
  runApp(ceo);
}

class TeacherDashboard extends StatelessWidget {
  //1. Property

  //2. Constructor

  //3. MEthod
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Teacher Dashboard'),
        ),
        body: Center(
          child: Text('Welcome to Teacher Dashboard'),
        ),
      ),
    );
  }
}
