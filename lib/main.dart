import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding JSON

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //1. Property
  //             VariableTYpe _ceo          = ClassName();
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passtextController = TextEditingController();
  final TextEditingController _cpasstextController = TextEditingController();

  //2. Constructor

  //3. Method

  void _handleSubmit() async {
    var userinputText = _usernametextController.text;
    var passinputText = _passtextController.text;
    var cpassinputText = _cpasstextController.text;
    // Perform any action with the input (e.g., print it or update the UI)
    print('Input Text: $userinputText');
    print('Input Text: $passinputText');
    print('Input Text: $cpassinputText');

    var url = Uri.parse('http://localhost:1337/api/auth/local/register');
    //Let preparet the payload
    var payload = jsonEncode({
      "username": userinputText,
      "email": passinputText,
      "password": cpassinputText
    });
    try {
      // Make the POST request
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: payload);
      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        //Show alert for
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("User Registered Successfully"),
              content: Text("User Registered Successfully"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
        print('User registered Successfully');
      } else {
        print('User registration Failed');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    /*
    POST http://localhost:1337/api/best-friends
      {
      "data": {
        "name": "Rohit"
      }
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _usernametextController,
            decoration: const InputDecoration(
              labelText: 'Enter your Username',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _passtextController,
            decoration: const InputDecoration(
              labelText: 'Enter your password',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _cpasstextController,
            decoration: const InputDecoration(
              labelText: 'Enter your confirm password',
              border: OutlineInputBorder(),
            ),
          ),
          // Submit Button (OK2)
          TextButton(
            onPressed: _handleSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
