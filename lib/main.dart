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
  //             VariableTYpe _ceo          = ClassName();
  final TextEditingController _textController = TextEditingController();

  void _handleSubmit() async {
    var inputText = _textController.text;
    // Perform any action with the input (e.g., print it or update the UI)
    print('Input Text: $inputText');

    var url = Uri.parse('http://localhost:1337/api/best-friends');
    //Let preparet the payload
    var payload = jsonEncode({
      "data": {"name": inputText}
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
        print('Successfully added: $inputText');
      } else {
        print('Failed to add friend. Status code: ${response.statusCode}');
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
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Enter your input',
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
