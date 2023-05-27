import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
  double width = 75;
  Color sidebarWidgetColorFirst = Color.fromARGB(255, 190, 145, 77);
  Color sidebarWidgetColorSec = Color.fromARGB(255, 190, 145, 77);
  Color sidebarIconColorFirst = Color.fromARGB(255, 72, 51, 43);
  Color sidebarIconColorSec = Color.fromARGB(255, 72, 51, 43);

  void _incWidth(PointerEnterEvent p) {
    setState(() {
      width = 150;
    });
  }

  void _decWidth(PointerEnterEvent) {
    setState(() {
      width = 75;
    });
  }

  List<Widget> _getChild(Icon icon, Text text) {
    if (width == 150) {
      return <Widget>[
        icon,
        AnimatedContainer(
            width: width - 80,
            duration: Duration(milliseconds: 200),
            child: text)
      ];
    } else {
      return <Widget>[icon];
    }
  }

  void _changeColorFirst(PointerEnterEvent) {
    if (sidebarWidgetColorFirst == Color.fromARGB(255, 190, 145, 77)) {
      setState(() {
        sidebarWidgetColorFirst = Color.fromARGB(255, 72, 51, 43);
        sidebarIconColorFirst = Color.fromARGB(255, 190, 145, 77);
      });
    } else {
      setState(() {
        sidebarWidgetColorFirst = Color.fromARGB(255, 190, 145, 77);
        sidebarIconColorFirst = Color.fromARGB(255, 72, 51, 43);
      });
    }
  }

  void _changeColorSecond(PointerEnterEvent) {
    if (sidebarWidgetColorSec == Color.fromARGB(255, 190, 145, 77)) {
      setState(() {
        sidebarWidgetColorSec = Color.fromARGB(255, 72, 51, 43);
        sidebarIconColorSec = Color.fromARGB(255, 190, 145, 77);
      });
    } else {
      setState(() {
        sidebarWidgetColorSec = Color.fromARGB(255, 190, 145, 77);
        sidebarIconColorSec = Color.fromARGB(255, 72, 51, 43);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 243, 226),
      body: Row(children: [
        Material(
            elevation: 10,
            child: MouseRegion(
                onEnter: _incWidth,
                onExit: _decWidth,
                child: AnimatedContainer(
                  color: Color.fromARGB(255, 210, 182, 149),
                  width: width,
                  duration: Duration(milliseconds: 200),
                  child: ListView(
                    children: <Widget>[
                      MouseRegion(
                          onEnter: _changeColorFirst,
                          onExit: _changeColorFirst,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedContainer(
                                  margin: EdgeInsets.all(10),
                                  width: width - 25,
                                  height: 50,
                                  duration: Duration(milliseconds: 200),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: sidebarWidgetColorFirst,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: _getChild(
                                          Icon(
                                            Icons.home,
                                            color: sidebarIconColorFirst,
                                          ),
                                          Text(
                                            "Home",
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: sidebarIconColorFirst),
                                          )))))),
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: Color.fromARGB(255, 190, 145, 77),
                          height: 1,
                          width: width - 10,
                        ),
                      ),
                      MouseRegion(
                          onEnter: _changeColorSecond,
                          onExit: _changeColorSecond,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedContainer(
                                  margin: EdgeInsets.all(10),
                                  width: width - 25,
                                  height: 50,
                                  duration: Duration(milliseconds: 200),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: sidebarWidgetColorSec,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: _getChild(
                                          Icon(Icons.lightbulb_outline,
                                              color: sidebarIconColorSec),
                                          Text("Generate Password",
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      sidebarIconColorSec)))))))
                    ],
                  ),
                )))
      ]),
    );
  }
}
