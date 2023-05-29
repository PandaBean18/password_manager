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
