import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../edit_pass.dart';
import 'package:postgres/postgres.dart';
import '../generator.dart';
import '../save_credentials.dart';
import '../add_pass.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pbkdf2ns/pbkdf2ns.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/services.dart';

class BaseApp extends StatefulWidget {
  String encKey;
  BaseApp(this.encKey, {super.key});

  @override
  State<BaseApp> createState() => _BaseAppState(encKey);
}

class _BaseAppState extends State<BaseApp> {
  String encKey;
  _BaseAppState(this.encKey);

  double width = 75;
  double elevation = 0;

  // colors
  Color black = Colors.black;
  Color green = Color.fromARGB(255, 1, 254, 94);
  Color beige = Color.fromARGB(255, 252, 252, 220);
  Color blue = Color.fromARGB(255, 0, 157, 255);

  //home
  double homeShadowRadius = 0;
  double homeLeftOffset = -5;
  double homeBottomOffset = 5;
  Color colorHome = Color.fromARGB(255, 1, 254, 94);
  Color homeShadowColor = Colors.black;
  // generator
  double genShadowRadius = 0;
  double genLeftOffset = 0;
  double genBottomOffset = 0;
  Color colorGen = Color.fromARGB(255, 252, 252, 220);
  Color genShadowColor = Color.fromARGB(255, 252, 252, 220);

  // pointer
  double y = 0.0;

  // Containers for password
  int current = 10;
  Color containerColor = Color.fromARGB(255, 252, 252, 220);
  Color containerDelColor = Color.fromARGB(255, 252, 252, 220);
  Color containerEditColor = Color.fromARGB(255, 252, 252, 220);

  // indv password container
  double passwordContainerWidth = 425;
  double passwordContainerHeight = 50;
  double passwordContainerLeftOffset = -5;
  double passwordContainerBottomOffset = 5;
  double passwordContainerMarginRight = 0;

  // indv delete container
  double delContainerWidth = 50;
  double delContainerHeight = 50;
  double delContainerLeftOffset = -5;
  double delContainerBottomOffset = 5;
  double delContainerMarginLeft = 10;
  double delContainerMarginRight = 0;

  // indv edit container
  double editContainerWidth = 50;
  double editContainerHeight = 50;
  double editContainerLeftOffset = -5;
  double editContainerBottomOffset = 5;
  double editContainerMarginRight = 0;

  // data
  List<dynamic> data = [];
  bool dataExtracted = false;
  List<dynamic> searchResults = [];
  List<dynamic> currrentDataList = [];

  void _changeElevation() {
    (elevation == 0) ? (elevation = 10) : (elevation = 0);
  }

  void _changeHomeColor() {
    (colorHome == green) ? (colorHome = blue) : (colorHome = green);
    // (homeLeftOffset == 0) ? (homeLeftOffset = -5) : (homeLeftOffset = 0);
    // (homeBottomOffset == 0) ? (homeBottomOffset = 5) : (homeBottomOffset = 0);
    // (homeShadowColor == Color.fromARGB(255, 1, 254, 94))
    //     ? (homeShadowColor = Colors.black)
    //     : (homeShadowColor = Color.fromARGB(255, 1, 254, 94));
  }

  void _changeGenColor() {
    (colorGen == beige) ? (colorGen = blue) : (colorGen = beige);
    (genLeftOffset == 0) ? (genLeftOffset = -5) : (genLeftOffset = 0);
    (genBottomOffset == 0) ? (genBottomOffset = 5) : (genBottomOffset = 0);
    (genShadowColor == beige)
        ? (genShadowColor = black)
        : (genShadowColor = beige);
  }

  void _updateY(PointerEvent details) {
    y = details.position.dy - 110;
    setState(() {
      current = (y / 60).floor();
    });
  }

  Future<void> showDeleteDialog(String applicationName) async {
    final String jsonString =
        await File('./database_params.json').readAsString();
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    await connection.open();

    final encryptionKey = Encrypt.Key.fromUtf8(encKey);
    final iv = Encrypt.IV.fromLength(16);
    final encrypter = Encrypt.Encrypter(Encrypt.AES(encryptionKey));
    final encryptedApplicatonName = encrypter.encrypt(applicationName, iv: iv);

    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                'Are you sure you want to delete the password for $applicationName?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await connection.query(
                      'DELETE FROM USER_DATA WHERE platform_name = @applicationName',
                      substitutionValues: {
                        "applicationName": encryptedApplicatonName.base64
                      });
                  await connection.close();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => BaseApp(encKey))));
                },
              )
            ],
          );
        });
  }

  Future<bool> getData() async {
    if (dataExtracted == false) {
      final String jsonString =
          await File('./database_params.json').readAsString();
      final params = json.decode(jsonString);
      var connection = PostgreSQLConnection(
          params['host'], params['port'], params['databaseName'],
          username: params['username'], password: params['password']);
      await connection.open();

      PostgreSQLResult results =
          await connection.query("SELECT * FROM USER_DATA");
      await connection.close();

      final encryptionKey = Encrypt.Key.fromUtf8(encKey);
      final iv = Encrypt.IV.fromLength(16);
      final encrypter = Encrypt.Encrypter(Encrypt.AES(encryptionKey));

      for (int i = 0; i < results.length; i++) {
        String applicationName = encrypter
            .decrypt(Encrypt.Encrypted.fromBase64(results[i][0]), iv: iv);

        String applicationPass = encrypter
            .decrypt(Encrypt.Encrypted.fromBase64(results[i][1]), iv: iv);

        data.add([applicationName, applicationPass]);
      }
      currrentDataList = data;
      dataExtracted = true;
    }

    return true;
  }

  void getSearchResults(String keyword) {
    keyword = keyword.toLowerCase();
    List<dynamic> currentSearchResults = [];
    for (int i = 0; i < data.length; i++) {
      List<String> current = data[i];
      if (current[0].toLowerCase().contains(keyword)) {
        currentSearchResults.add(current);
      }
    }
    searchResults = currentSearchResults;
  }

  List<Widget> _getChildren(data) {
    int i = 0;
    List<Widget> children = [];
    while (i < data.length) {
      if (i == current) {
        String copyText = ' (Click to copy)';
        children.add(Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 125,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                      color: beige,
                      border: Border.all(),
                      boxShadow: [BoxShadow(offset: Offset(-5, 5))]),
                  child: Text(
                    data[i][0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      containerColor = blue;
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      containerColor = beige;
                    });
                  },
                  child: InkWell(
                      onTap: () async {},
                      child: Listener(
                          onPointerDown: (event) async {
                            setState(() {
                              passwordContainerWidth = 420;
                              passwordContainerHeight = 45;
                              passwordContainerLeftOffset = 0;
                              passwordContainerBottomOffset = 0;
                              passwordContainerMarginRight = 5;
                            });
                            await Clipboard.setData(
                                ClipboardData(text: data[current][1]));
                          },
                          onPointerUp: (event) {
                            setState(() {
                              passwordContainerWidth = 425;
                              passwordContainerHeight = 50;
                              passwordContainerLeftOffset = -5;
                              passwordContainerBottomOffset = 5;
                              passwordContainerMarginRight = 0;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            height: passwordContainerHeight,
                            width: passwordContainerWidth,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                                10, 10, passwordContainerMarginRight, 10),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color: containerColor,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(
                                          passwordContainerLeftOffset,
                                          passwordContainerBottomOffset))
                                ]),
                            child: Text(data[current][1] + copyText,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ))),
                ),
                MouseRegion(
                    onHover: (event) {
                      setState(() {
                        containerDelColor = Colors.red;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        containerDelColor = beige;
                      });
                    },
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            showDeleteDialog(data[current][0]);
                          });
                        },
                        child: Listener(
                            onPointerDown: (event) {
                              setState(() {
                                delContainerHeight -= 5;
                                delContainerWidth -= 5;
                                delContainerLeftOffset += 5;
                                delContainerBottomOffset -= 5;
                                delContainerMarginLeft += 2.5;
                                delContainerMarginRight += 2.5;
                              });
                            },
                            onPointerUp: (event) {
                              setState(() {
                                delContainerHeight += 5;
                                delContainerWidth += 5;
                                delContainerLeftOffset -= 5;
                                delContainerBottomOffset += 5;
                                delContainerMarginLeft -= 2.5;
                                delContainerMarginRight -= 2.5;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              height: delContainerHeight,
                              width: delContainerWidth,
                              margin: EdgeInsets.fromLTRB(
                                  delContainerMarginLeft,
                                  10,
                                  delContainerMarginRight,
                                  10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: containerDelColor,
                                  border: Border.all(),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(delContainerLeftOffset,
                                            delContainerBottomOffset))
                                  ]),
                              child: Icon(Icons.delete),
                            )))),
                MouseRegion(
                    onHover: (event) {
                      setState(() {
                        containerEditColor = green;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        containerEditColor = beige;
                      });
                    },
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditPass(
                                      data[current][0], data[current][1]))));
                        },
                        child: Listener(
                            onPointerDown: (event) {
                              setState(() {
                                editContainerWidth -= 5;
                                editContainerHeight -= 5;
                                editContainerLeftOffset += 5;
                                editContainerBottomOffset -= 5;
                                editContainerMarginRight += 5;
                              });
                            },
                            onPointerUp: (event) {
                              setState(() {
                                editContainerWidth += 5;
                                editContainerHeight += 5;
                                editContainerLeftOffset -= 5;
                                editContainerBottomOffset += 5;
                                editContainerMarginRight -= 5;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              height: editContainerHeight,
                              width: editContainerWidth,
                              margin: EdgeInsets.fromLTRB(
                                  10, 10, editContainerMarginRight, 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: containerEditColor,
                                  border: Border.all(),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(editContainerLeftOffset,
                                            editContainerBottomOffset))
                                  ]),
                              child: Icon(Icons.create_rounded),
                            ))))
              ],
            )));
      } else {
        children.add(Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 125,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: beige,
                    border: Border.all(),
                    boxShadow: [BoxShadow(offset: Offset(-5, 5))],
                  ),
                  child: Text(
                    data[i][0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: 425,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: beige,
                      boxShadow: [BoxShadow(offset: Offset(-5, 5))]),
                  child: Text(('•' * data[i][1].length),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: beige,
                      border: Border.all(),
                      boxShadow: [BoxShadow(offset: Offset(-5, 5))]),
                  child: Icon(Icons.delete),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: beige,
                      border: Border.all(),
                      boxShadow: [BoxShadow(offset: Offset(-5, 5))]),
                  child: Icon(Icons.create_rounded),
                )
              ],
            )));
      }
      i++;
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == null) {
            return const Center(
                child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ));
          }
          return Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('./assets/app_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Row(children: [
                      Material(
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 150,
                            color: const Color.fromARGB(255, 252, 252, 220),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 200,
                                  child: Column(children: [
                                    AnimatedContainer(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      height: 50,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 125,
                                      decoration: BoxDecoration(
                                          color: colorHome,
                                          boxShadow: [
                                            BoxShadow(
                                                color: homeShadowColor,
                                                spreadRadius: homeShadowRadius,
                                                offset: Offset(homeLeftOffset,
                                                    homeBottomOffset))
                                          ]),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap: () {},
                                          child: MouseRegion(
                                            onEnter: (event) {
                                              setState(() {
                                                _changeHomeColor();
                                              });
                                            },
                                            onExit: (event) {
                                              setState(() {
                                                _changeHomeColor();
                                              });
                                            },
                                            child: Container(
                                                height: 50,
                                                width: 125,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Home',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          )),
                                    ),
                                    AnimatedContainer(
                                      height: 50,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 125,
                                      decoration: BoxDecoration(
                                          color: colorGen,
                                          boxShadow: [
                                            BoxShadow(
                                                color: genShadowColor,
                                                spreadRadius: genShadowRadius,
                                                offset: Offset(genLeftOffset,
                                                    genBottomOffset))
                                          ]),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        Generator(encKey))));
                                          },
                                          child: MouseRegion(
                                            onEnter: (event) {
                                              setState(() {
                                                _changeGenColor();
                                              });
                                            },
                                            onExit: (event) {
                                              setState(() {
                                                _changeGenColor();
                                              });
                                            },
                                            child: Container(
                                                height: 50,
                                                width: 125,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Generate Password',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          )),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          child: Center(
                        child: Container(
                          //height: 500,
                          width: 700,
                          padding: EdgeInsets.all(10),

                          child: Column(
                            children: [
                              // Search bar
                              Container(
                                height: 50,
                                width: 680,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              getSearchResults(value);
                                              currrentDataList = searchResults;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Search'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Some name on the left like "Websites" and a '+' on right
                              Container(
                                  height: 30,
                                  width: 680,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  //padding: EdgeInsets.all(10),
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(),
                                  // ),
                                  child: Row(children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      width: 125,
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text('Application',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      width: 425,
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text('Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      AddPass())));
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                    ))
                                  ])),
                              // list containing all passwords
                              Expanded(
                                  child: MouseRegion(
                                      onHover: _updateY,
                                      onExit: (event) {
                                        setState(() {
                                          current = 10;
                                        });
                                      },
                                      child: Container(
                                          child: ListView(
                                              children: _getChildren(
                                                  currrentDataList)))))
                            ],
                          ),
                        ),
                      ))
                    ]))),
          );
        });
  }
}
