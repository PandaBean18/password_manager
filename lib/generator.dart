import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../home.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  double width = 75;
  double currentSliderValue = 8;
  Color sidebarWidgetColorFirst = Color.fromARGB(255, 190, 145, 77);
  Color sidebarWidgetColorSec = Color.fromARGB(255, 190, 145, 77);
  Color sidebarIconColorFirst = Color.fromARGB(255, 72, 51, 43);
  Color sidebarIconColorSec = Color.fromARGB(255, 72, 51, 43);
  bool useSymbols = true;
  bool useNumbers = true;
  String password = '';
  String text = 'Copy to clipboard';

  String _generatePassword() {
    String alpha = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String numbers = '0123456789';
    String sym = "!@#^&*";
    String pass = '';

    if (useSymbols && useNumbers) {
      int num_symbols = 0;
      int num_nums = 0;
      int num_alphas = 0;
      int i = 0;

      while ((i < currentSliderValue) || (num_symbols < 1) || (num_nums < 1)) {
        Random random = new Random();
        int c = random.nextInt(4);

        if (c == 0) {
          Random char_idx = new Random();
          pass += numbers[char_idx.nextInt(numbers.length)];
          num_nums += 1;
          i += 1;
        } else if (c == 1) {
          Random char_idx = new Random();
          pass += sym[char_idx.nextInt(sym.length)];
          num_symbols += 1;
          i += 1;
        } else {
          if (num_alphas == currentSliderValue - 2) {
            continue;
          }
          Random char_idx = new Random();
          pass += alpha[char_idx.nextInt(alpha.length)];
          num_alphas += 1;
          i += 1;
        }

        if ((i == currentSliderValue) && (num_symbols < 1 || num_nums < 1)) {
          i -= 1;
          num_alphas -= 1;
          password = password.substring(1, (currentSliderValue - 1).round());
        }
      }
    } else if (useSymbols) {
      int num_symbols = 0;
      int num_alphas = 0;
      int i = 0;

      while ((i < currentSliderValue) || (num_symbols < 1)) {
        Random random = new Random();
        int c = random.nextInt(3);

        if (c == 0) {
          Random char_idx = new Random();
          pass += sym[char_idx.nextInt(sym.length)];
          i += 1;
          num_symbols += 1;
        } else {
          if (num_alphas == currentSliderValue - 1) {
            continue;
          }
          Random char_idx = new Random();
          pass += alpha[char_idx.nextInt(alpha.length)];
          num_alphas += 1;
          i += 1;
        }

        if ((i == currentSliderValue) && (num_symbols < 1)) {
          i -= 1;
          password = password.substring(1, (currentSliderValue - 1).round());
        }
      }
    } else if (useNumbers) {
      int num_nums = 0;
      int num_alphas = 0;
      int i = 0;

      while ((i < currentSliderValue) || (num_nums < 1)) {
        Random random = new Random();
        int c = random.nextInt(3);

        if (c == 0) {
          Random char_idx = new Random();
          pass += numbers[char_idx.nextInt(numbers.length)];
          i += 1;
          num_nums += 1;
        } else {
          if (num_alphas == currentSliderValue - 2) {
            continue;
          }
          Random char_idx = new Random();
          pass += alpha[char_idx.nextInt(alpha.length)];
          i += 1;
          num_alphas += 1;
        }

        if ((i == currentSliderValue) && (num_nums < 1)) {
          i -= 1;
          password = password.substring(1, (currentSliderValue - 1).round());
        }
      }
    } else {
      int i = 0;

      while (i < currentSliderValue) {
        Random char_idx = new Random();

        pass += alpha[char_idx.nextInt(alpha.length)];
        i += 1;
      }
    }
    return pass;
  }

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

  Color _getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color.fromARGB(255, 79, 85, 88);
    }
    return Color.fromARGB(255, 72, 51, 43);
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
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => BaseApp())))
                              },
                          child: MouseRegion(
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
                                                    color:
                                                        sidebarIconColorFirst),
                                              ))))))),
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          color: Color.fromARGB(255, 190, 145, 77),
                          height: 1,
                          width: width - 10,
                        ),
                      ),
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => Generator())))
                              },
                          child: MouseRegion(
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
                                                          sidebarIconColorSec)))))))),
                    ],
                  ),
                ))),
        Container(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Generate Password',
              style: TextStyle(
                  color: Color.fromARGB(255, 79, 85, 88), fontSize: 50),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password Length:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 116, 137, 147),
                          fontSize: 25),
                    ),
                    Slider(
                      value: currentSliderValue,
                      min: 6,
                      max: 32,
                      divisions: 26,
                      label: currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValue = value;
                        });
                      },
                      activeColor: Color.fromARGB(255, 190, 145, 77),
                      inactiveColor: Color.fromARGB(255, 72, 51, 43),
                    ),
                    Text(
                      currentSliderValue.round().toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 116, 137, 147),
                          fontSize: 25),
                    )
                  ],
                )),
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Constraints:',
                  style: TextStyle(
                      color: Color.fromARGB(255, 116, 137, 147), fontSize: 25),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Color.fromARGB(255, 190, 145, 77),
                    fillColor: MaterialStateProperty.resolveWith(_getColor),
                    value: useSymbols,
                    onChanged: (value) {
                      setState(() {
                        useSymbols = value!;
                      });
                    },
                  ),
                  Text(
                    '    Use symbols',
                    style: TextStyle(
                        color: Color.fromARGB(255, 116, 137, 147),
                        fontSize: 15),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Color.fromARGB(255, 190, 145, 77),
                    fillColor: MaterialStateProperty.resolveWith(_getColor),
                    value: useNumbers,
                    onChanged: (value) {
                      setState(() {
                        useNumbers = value!;
                      });
                    },
                  ),
                  Text(
                    '    Use numbers',
                    style: TextStyle(
                        color: Color.fromARGB(255, 116, 137, 147),
                        fontSize: 15),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                password = _generatePassword();
                                text = 'Copy to clipboard';
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 72, 51, 43),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text('Generate',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 190, 145, 77))),
                            ))),
                    Row(
                      children: [
                        Container(
                          width: 300,
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 72, 51, 43),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            password,
                            style: TextStyle(
                                color: Color.fromARGB(255, 190, 145, 77)),
                          ),
                        ),
                        Container(
                          width: 175,
                          height: 39,
                          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 190, 145, 77),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: InkWell(
                              onTap: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: password));
                                setState(() {
                                  text = 'Copied';
                                });
                                // copied successfully
                              },
                              child: Text(
                                text,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 72, 51, 43)),
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    )
                  ],
                )),
          ]),
        )
      ]),
    );
  }
}
