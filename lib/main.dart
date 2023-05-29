import 'package:flutter/material.dart';
import '../home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Fragment'),
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                                  builder: ((context) => PasswordInput())));
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
  const PasswordInput({super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;

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
                      'Please enter your password',
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
                        onTap: () {
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
