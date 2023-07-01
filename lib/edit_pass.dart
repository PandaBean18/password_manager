import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:pbkdf2ns/pbkdf2ns.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as Encrypt;
import '../home.dart';

class EditPass extends StatefulWidget {
  String applicationName;
  String applicationPassword;
  EditPass(this.applicationName, this.applicationPassword, {super.key});

  @override
  State<EditPass> createState() =>
      _EditPassState(applicationName, applicationPassword);
}

class _EditPassState extends State<EditPass> {
  String initialApplicationName;
  String applicationPassword;
  _EditPassState(this.initialApplicationName, this.applicationPassword);

  String applicationName = '';

  String password = '';
  bool obscureText = true;
  bool obscurePass = true;

  // colors
  Color black = Colors.black;
  Color green = const Color.fromARGB(255, 1, 254, 94);
  Color beige = const Color.fromARGB(255, 252, 252, 220);
  Color blue = const Color.fromARGB(255, 0, 157, 255);

  // back button
  double backContainerHeight = 50;
  double backContainerWidth = 125;
  double backContainerLeftOffset = -5;
  double backContainerBottomOffset = 5;
  double backContainerTopMargin = 10;
  double backContainerBottomMargin = 10;
  double backContainerLeftMargin = 10;
  double backContainerRightMargin = 215;

  // next button
  double nextContainerHeight = 50;
  double nextContainerWidth = 125;
  double nextContainerLeftOffset = -5;
  double nextContainerBottomOffset = 5;
  double nextContainerTopMargin = 10;
  double nextContainerBottomMargin = 10;
  double nextContainerLeftMargin = 215;
  double nextContainerRightMargin = 10;

  Future<bool> checkPassword(String pass) async {
    final String jsonString =
        await File('./database_params.json').readAsString();
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    await connection.open();

    PostgreSQLResult result = await connection.query("SELECT * FROM USERS");
    await connection.close();
    String hashed = result[0][1];
    return BCrypt.checkpw(password, hashed);
  }

  String createEncryptionKey() {
    PBKDF2NS gen = PBKDF2NS(hash: sha256);
    List<int> key = gen.generateKey(password, "Aqx@0&^*&r92055eW9^C", 1000, 24);

    password = '';
    return base64.encode(key);
  }

  Future<bool> insertData(String key) async {
    final String jsonString =
        await File('./database_params.json').readAsString();
    final params = json.decode(jsonString);
    var connection = PostgreSQLConnection(
        params['host'], params['port'], params['databaseName'],
        username: params['username'], password: params['password']);
    await connection.open();

    final encryptionKey = Encrypt.Key.fromUtf8(key);
    final iv = Encrypt.IV.fromLength(16);
    final encrypter = Encrypt.Encrypter(Encrypt.AES(encryptionKey));

    final encryptedApplicationName = (applicationName == '')
        ? encrypter.encrypt(initialApplicationName, iv: iv)
        : encrypter.encrypt(applicationName, iv: iv);
    final encryptedApplicationPassword =
        encrypter.encrypt(applicationPassword, iv: iv);
    final encryptedInitialName =
        encrypter.encrypt(initialApplicationName, iv: iv);

    applicationName = '';
    applicationPassword = '';
    try {
      await connection.query(
          "UPDATE USER_DATA SET platform_name = @applicationName, password_digest = @applicationPassword WHERE platform_name = @initialApplicationName",
          substitutionValues: {
            "applicationName": encryptedApplicationName.base64,
            "applicationPassword": encryptedApplicationPassword.base64,
            "initialApplicationName": encryptedInitialName.base64
          });
      await connection.close();
      return true;
    } catch (e) {
      print(e);
      await connection.close();
      return false;
    }
  }

  Future<void> showErrorDialog(String error) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error, style: TextStyle(color: Colors.red)),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> showPasswordDialog() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Text('Please enter your password'),
                TextField(
                  obscureText: obscurePass,
                  onChanged: (value) {
                    password = value;
                  },
                )
              ],
            )),
            actions: <Widget>[
              TextButton(
                child: const Text('Go Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (await checkPassword(password) as bool) {
                    String key = createEncryptionKey();
                    bool status = await insertData(key);

                    if (status) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => BaseApp(key))));
                    } else {
                      await showErrorDialog('Something went wrong');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => BaseApp(key))));
                    }
                  } else {
                    await showErrorDialog('Incorrect password');
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: Container(
              width: 741,
              height: 300,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: beige,
                  border: Border.all(),
                  boxShadow: const [BoxShadow(offset: Offset(-5, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Password',
                    style: TextStyle(color: Colors.black, fontSize: 50),
                  ),
                  Container(
                    height: 60,
                    child: Row(children: [
                      Text(
                        'Application name:',
                        style: TextStyle(
                            color: Color.fromARGB(255, 72, 84, 90),
                            fontSize: 25),
                      ),
                      Container(
                          width: 500,
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            initialValue: initialApplicationName,
                            onChanged: (value) {
                              applicationName = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Application Name'),
                          )),
                    ]),
                  ),
                  Container(
                    height: 60,
                    child: Row(children: [
                      Text(
                        'Application password:',
                        style: TextStyle(
                            color: Color.fromARGB(255, 72, 84, 90),
                            fontSize: 25),
                      ),
                      Container(
                          width: 400,
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            initialValue: applicationPassword,
                            obscureText: obscureText,
                            onChanged: (value) {
                              applicationPassword = value;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Application Password'),
                          )),
                      Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText
                                      ? (obscureText = false)
                                      : (obscureText = true);
                                });
                              },
                              child: Icon(Icons.remove_red_eye)))
                    ]),
                  ),
                  Expanded(
                      child: Container(
                    width: 721,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Listener(
                                onPointerDown: (event) {
                                  setState(() {
                                    backContainerHeight -= 5;
                                    backContainerWidth -= 5;
                                    backContainerLeftOffset += 5;
                                    backContainerBottomOffset -= 5;
                                    backContainerLeftMargin += 2.5;
                                    backContainerRightMargin += 2.5;
                                  });
                                },
                                onPointerUp: (event) {
                                  setState(() {
                                    backContainerHeight += 5;
                                    backContainerWidth += 5;
                                    backContainerLeftOffset -= 5;
                                    backContainerBottomOffset += 5;
                                    backContainerLeftMargin -= 2.5;
                                    backContainerRightMargin -= 2.5;
                                  });
                                },
                                child: Container(
                                    height: backContainerHeight,
                                    width: backContainerWidth,
                                    margin: EdgeInsets.fromLTRB(
                                        backContainerLeftMargin,
                                        backContainerTopMargin,
                                        backContainerRightMargin,
                                        backContainerBottomMargin),
                                    decoration: BoxDecoration(
                                        color: blue,
                                        border: Border.all(),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(
                                                  backContainerLeftOffset,
                                                  backContainerBottomOffset))
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.navigate_before, size: 30),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text('Return',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ))))
                                      ],
                                    )))),
                        InkWell(
                            onTap: () {
                              setState(() {
                                showPasswordDialog();
                              });
                            },
                            child: Listener(
                                onPointerDown: (event) {
                                  setState(() {
                                    nextContainerHeight -= 5;
                                    nextContainerWidth -= 5;
                                    nextContainerLeftOffset += 5;
                                    nextContainerBottomOffset -= 5;
                                    nextContainerLeftMargin += 2.5;
                                    nextContainerRightMargin += 2.5;
                                  });
                                },
                                onPointerUp: (event) {
                                  setState(() {
                                    nextContainerHeight += 5;
                                    nextContainerWidth += 5;
                                    nextContainerLeftOffset -= 5;
                                    nextContainerBottomOffset += 5;
                                    nextContainerLeftMargin -= 2.5;
                                    nextContainerRightMargin -= 2.5;
                                  });
                                },
                                child: Container(
                                    height: nextContainerHeight,
                                    width: nextContainerWidth,
                                    margin: EdgeInsets.fromLTRB(
                                        nextContainerLeftMargin,
                                        nextContainerTopMargin,
                                        nextContainerRightMargin,
                                        nextContainerBottomMargin),
                                    decoration: BoxDecoration(
                                        color: blue,
                                        border: Border.all(),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(
                                                  nextContainerLeftOffset,
                                                  nextContainerBottomOffset))
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text('Proceed',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )))),
                                        Icon(Icons.navigate_next, size: 30),
                                      ],
                                    ))))
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
