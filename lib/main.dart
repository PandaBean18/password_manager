import 'package:flutter/material.dart';

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
      home: BaseApp(),
    );
  }
}

class BaseApp extends StatefulWidget {
  const BaseApp({super.key});

  @override
  State<BaseApp> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(255, 210, 182, 149)),
          title: Text('Lauda',
              style: TextStyle(color: Color.fromARGB(255, 73, 79, 87))),
          backgroundColor: Color.fromARGB(255, 251, 243, 226),
        ),
        backgroundColor: Color.fromARGB(255, 251, 243, 226),
        body: Center(child: Text('Lauda')));
  }
}

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 210, 182, 149),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Back'),
              onTap: () => {Navigator.of(context).pop()})
        ],
      ),
    );
  }
}
