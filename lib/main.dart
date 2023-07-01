import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home.dart';
import 'package:postgres/postgres.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:pbkdf2ns/pbkdf2ns.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<StatefulWidget> getHome() async {
    final String jsonString =
        await rootBundle.loadString('assets/database_params.json');
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    await connection.open();
    try {
      PostgreSQLResult results = await connection.query('SELECT * FROM USERS');
      await connection.close();
      if (results.length == 0) {
        return SignUp();
      } else {
        return SignIn();
      }
    } catch (e) {
      print(e);
      await connection.close();
      return SignUp();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHome(),
      builder: (BuildContext context, AsyncSnapshot<StatefulWidget> snapshot) {
        StatefulWidget home = SignUp();
        if (snapshot.data == null) {
          return const Center(
              child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ));
        } else {
          home = snapshot.data as StatefulWidget;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: home,
        );
      },
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
  String encKey = '';

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
                        ])),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          final String jsonString =
                              await DefaultAssetBundle.of(context)
                                  .loadString("assets/database_params.json");
                          ;
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
                          await connection.close();

                          PBKDF2NS gen = PBKDF2NS(hash: sha256);
                          List<int> key = gen.generateKey(
                              password, "Aqx@0&^*&r92055eW9^C", 1000, 24);

                          password = '';
                          encKey = base64.encode(key);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => BaseApp(encKey))));
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

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController passwordController;
  bool obscureText = true;
  String password = '';
  String encKey = '';
  String hashed = '';
  String username = '';
  String error = '';

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

  Future<PostgreSQLResult> getCreds() async {
    final String jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/database_params.json");
    ;
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    await connection.open();

    PostgreSQLResult result = await connection.query('SELECT * FROM USERS');
    await connection.close();
    return result;
  }

  Future<bool> chechPW(String password) async {
    return BCrypt.checkpw(password, hashed);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCreds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PostgreSQLResult result = snapshot.data as PostgreSQLResult;
          hashed = result[0][1];
          username = result[0][0];
        } else {
          return Center(
              child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ));
        }

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
                        'Welcome $username,\nPlease enter your password.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 79, 85, 88),
                          fontSize: 35,
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
                          ])),
                      (error == '')
                          ? Text('')
                          : Text(error,
                              style: TextStyle(
                                color: Color.fromARGB(255, 195, 45, 70),
                                fontSize: 20,
                              )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async {
                            if (await chechPW(password) as bool) {
                              PBKDF2NS gen = PBKDF2NS(hash: sha256);
                              List<int> key = gen.generateKey(
                                  password, "Aqx@0&^*&r92055eW9^C", 1000, 24);

                              password = '';
                              encKey = base64.encode(key);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => BaseApp(encKey))));
                            } else {
                              setState(() {
                                error = 'Incorrect password';
                              });
                            }
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
