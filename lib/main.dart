import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // jsonEncode/jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Import all 3 roles dashboard page
import 'student/dashboard.dart';
import 'parent/dashboard.dart';
import 'teacher/dashboard.dart';

void main() async {
  await dotenv.load(fileName: "/.env", mergeWith: {
    'TEST_VAR': '5',
  }); // mergeWith optional, you can include Platform.environment for Mobile/Desktop app
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
  @override
  void initState() {
    //After page load
    // Call _getToken as soon as the widget is initialized
    _getToken();
  }

  // Method to retrieve the token from SharedPreferences
  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    print('Stored Token: $token');
  }

  // Save login information in shared_preferences
  Future<void> _saveLoginInfo(String resData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', jsonEncode(resData)); // Store token

    _getToken();
  }

  void _handleSubmit() async {
    var userinputText = _usernametextController.text;
    var passinputText = _passtextController.text;
    // Perform any action with the input (e.g., print it or update the UI)
    print('Input Text: $userinputText');
    print('Input Text: $passinputText');
    // Get the base URL from the .env file
    var baseUrl = dotenv.env['BASE_URL'];
    var url = Uri.parse('$baseUrl/api/auth/local');
    //Let preparet the payload
    var payload = jsonEncode({
      "identifier": userinputText,
      "password": passinputText,
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
        //var responseData = jsonDecode(response.body);
        await _saveLoginInfo(response.body); // Save token locally
        // Save the respone in SharedPreferences
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //await prefs.setString('userData', responseData); // Store token
        // Extract user_role from the response
        //var userRole = response.body['user']['user_role'];
        print("response.body>>>>>");
        print(response.body);
        print(
            'Type of response.body: ${response.body.runtimeType}'); // Print the type of the response body
        var x = jsonDecode(response.body);
        print(
            'Type of response.body: ${x.runtimeType}'); // Print the type of the response body
        print('>>>>>>Anil');
        print(x["user"]['user_role']);
        var userRole = x["user"]['user_role'];
        //* / Navigate to different dashboards based on user_role
        if (userRole == 'student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard()),
          );
        } else if (userRole == 'parent') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ParentDashboard()),
          );
        } else if (userRole == 'teacher') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeacherDashboard()),
          );
        }

        /* showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("User Logged In Successfully"),
              content: Text("User Logged In Successfully"),
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
        print('User registered Successfully'); */
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("User Login Failed"),
              content: Text("Please enter valid credentials"),
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
            obscureText: true, // This makes it a password field
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
