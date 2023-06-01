import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home.dart';
import 'package:postgres/postgres.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  StatefulWidget home = SignUp();
  void getHome() async {
    final String jsonString =
        await File('./database_params.json').readAsString();
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    connection.open();
    try {
      await connection.query('SELECT * FROM users');
    } catch (e) {
      home = SignUp();
    }
    home = SignUp();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getHome();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Fragment'),
      home: home,
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  String username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 243, 226),
      body: Center(
        child: Container(
          height: 370,
          width: 300,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 251, 243, 226),
              border: Border.all(color: Color.fromARGB(100, 72, 51, 43)),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome,\nPlease enter a username',
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 85, 88),
                        fontSize: 35,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text('This is how we will refer you.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 79, 85, 88),
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextField(
                      controller: usernameController,
                      onChanged: (String value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Username'),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      PasswordInput(username: username))));
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 79, 85, 88),
                                  fontSize: 25,
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Color.fromARGB(255, 79, 85, 88),
                                size: 45,
                              )
                            ])))
                  ],
                )
              ]),
        ),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String username;
  const PasswordInput({Key? key, required this.username}) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late TextEditingController passwordController;
  bool obscureText = true;
  String password = '';

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 243, 226),
      body: Center(
        child: Container(
          height: 370,
          width: 300,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 251, 243, 226),
              border: Border.all(color: Color.fromARGB(100, 72, 51, 43)),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi ${this.widget.username}, please enter your password',
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 85, 88),
                        fontSize: 35,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      'Pick something strong and memorable. You will need this to access the app',
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 85, 88),
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                        width: 280,
                        child: Row(children: [
                          Flexible(
                              child: TextField(
                            controller: passwordController,
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: obscureText,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Password'),
                          )),
                          Container(
                              margin: EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscureText
                                        ? (obscureText = false)
                                        : (obscureText = true);
                                  });
                                },
                                child: Icon(Icons.remove_red_eye),
                              ))
                        ]))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          final String jsonString =
                              await File('./database_params.json')
                                  .readAsString();
                          final params = json.decode(jsonString);
                          var connection = PostgreSQLConnection(params['host'],
                              params['port'], params['databaseName'],
                              username: params['username'],
                              password: params['password']);
                          await connection.open();
                          password = BCrypt.hashpw(password, BCrypt.gensalt());
                          await connection.query(
                              'INSERT INTO USERS (username, password_digest) VALUES (@username, @password)',
                              substitutionValues: {
                                "username": widget.username,
                                "password": password
                              });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => BaseApp())));
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 79, 85, 88),
                                  fontSize: 25,
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Color.fromARGB(255, 79, 85, 88),
                                size: 35,
                              )
                            ])))
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
