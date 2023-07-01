import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:io';
import '../home.dart';

class Generator extends StatefulWidget {
  String encKey;
  Generator(this.encKey, {super.key});

  @override
  State<Generator> createState() => _GeneratorState(encKey);
}

class _GeneratorState extends State<Generator> {
  String encKey;
  _GeneratorState(this.encKey);

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

  // colors
  Color black = Colors.black;
  Color green = Color.fromARGB(255, 1, 254, 94);
  Color beige = Color.fromARGB(255, 252, 252, 220);
  Color blue = Color.fromARGB(255, 0, 157, 255);

  //home
  double homeShadowRadius = 0;
  double homeLeftOffset = 0;
  double homeBottomOffset = 0;
  Color colorHome = Color.fromARGB(255, 252, 252, 220);
  Color homeShadowColor = Color.fromARGB(255, 252, 252, 220);
  // generator
  double genShadowRadius = 0;
  double genLeftOffset = -5;
  double genBottomOffset = 5;
  Color colorGen = Color.fromARGB(255, 1, 254, 94);
  Color genShadowColor = Colors.black;
  // button
  double buttonOffsetLeft = -5;
  double buttonOffsetBottom = 5;
  double buttonHeight = 50;
  double buttonWidth = 150;

  //copy button
  double copyButtonOffsetLeft = -5;
  double copyButtonOffsetBottom = 5;
  double copyButtonHeight = 40;
  double copyButtonWidth = 175;
  double copyButtonMargin = 0;

  void _changeHomeColor() {
    (colorHome == beige) ? (colorHome = blue) : (colorHome = beige);
    (homeLeftOffset == 0) ? (homeLeftOffset = -5) : (homeLeftOffset = 0);
    (homeBottomOffset == 0) ? (homeBottomOffset = 5) : (homeBottomOffset = 0);
    (homeShadowColor == beige)
        ? (homeShadowColor = black)
        : (homeShadowColor = beige);
  }

  void _changeGenColor() {
    (colorGen == green) ? (colorGen = blue) : (colorGen = green);
    // (genLeftOffset == 0) ? (genLeftOffset = -5) : (genLeftOffset = 0);
    // (genBottomOffset == 0) ? (genBottomOffset = 5) : (genBottomOffset = 0);
    // (genShadowColor == beige)
    //     ? (genShadowColor = black)
    //     : (genShadowColor = beige);
  }

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

  void _pressButton(bool rev) {
    if (rev) {
      setState(() {
        buttonHeight = 50;
        buttonWidth = 150;
        buttonOffsetBottom = 5;
        buttonOffsetLeft = -5;
      });
    } else {
      setState(() {
        buttonHeight = 45;
        buttonWidth = 145;
        buttonOffsetBottom = 0;
        buttonOffsetLeft = 0;
      });
      sleep(Duration(milliseconds: 10));
      _pressButton(true);
    }
  }

  Color _getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return blue;
    }
    return blue;
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
                                duration: const Duration(milliseconds: 200),
                                width: 125,
                                decoration:
                                    BoxDecoration(color: colorHome, boxShadow: [
                                  BoxShadow(
                                      color: homeShadowColor,
                                      spreadRadius: homeShadowRadius,
                                      offset: Offset(
                                          homeLeftOffset, homeBottomOffset))
                                ]),
                                alignment: Alignment.center,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  BaseApp(encKey))));
                                    },
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
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )),
                              ),
                              AnimatedContainer(
                                height: 50,
                                duration: const Duration(milliseconds: 200),
                                width: 125,
                                decoration:
                                    BoxDecoration(color: colorGen, boxShadow: [
                                  BoxShadow(
                                      color: genShadowColor,
                                      spreadRadius: genShadowRadius,
                                      offset: Offset(
                                          genLeftOffset, genBottomOffset))
                                ]),
                                alignment: Alignment.center,
                                child: InkWell(
                                    onTap: () {},
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
                                                fontWeight: FontWeight.bold),
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
                  width: 800,
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Password',
                          style: TextStyle(color: Colors.black, fontSize: 50),
                        ),
                        Container(
                            width: 500,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Password Length:',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 72, 84, 90),
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
                                  activeColor:
                                      Color.fromARGB(255, 255, 165, 97),
                                  inactiveColor: beige,
                                ),
                                Text(
                                  currentSliderValue.round().toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 72, 84, 90),
                                      fontSize: 25),
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Constraints:',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 84, 90),
                                  fontSize: 25),
                            )),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                fillColor: MaterialStateProperty.resolveWith(
                                    _getColor),
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
                                    color: Color.fromARGB(255, 72, 84, 90),
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
                                checkColor: Colors.black,
                                fillColor: MaterialStateProperty.resolveWith(
                                    _getColor),
                                value: useNumbers,
                                onChanged: (value) {
                                  setState(() {
                                    useNumbers = value!;
                                  });
                                },
                              ),
                              const Text(
                                '    Use numbers',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 72, 84, 90),
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
                                    //elevation: 10,
                                    child: InkWell(
                                        onTap: () {},
                                        child: Listener(
                                            onPointerDown: (event) {
                                              setState(() {
                                                password = _generatePassword();
                                                text = 'Copy to clipboard';
                                                buttonHeight = 45;
                                                buttonWidth = 145;
                                                buttonOffsetBottom = 0;
                                                buttonOffsetLeft = 0;
                                              });
                                            },
                                            onPointerUp: (event) {
                                              setState(() {
                                                buttonHeight = 50;
                                                buttonWidth = 150;
                                                buttonOffsetBottom = 5;
                                                buttonOffsetLeft = -5;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 5),
                                              height: buttonHeight,
                                              width: buttonWidth,
                                              decoration: BoxDecoration(
                                                  color: blue,
                                                  border: Border.all(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(
                                                          buttonOffsetLeft,
                                                          buttonOffsetBottom),
                                                    )
                                                  ]),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Generate',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )))),
                                Row(
                                  children: [
                                    Container(
                                      width: 300,
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: beige,
                                          border: Border.all(),
                                          boxShadow: const [
                                            BoxShadow(offset: Offset(-5, 5))
                                          ]),
                                      child: Text(
                                        password,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await Clipboard.setData(
                                            ClipboardData(text: password));
                                        setState(() {
                                          text = 'Copied';
                                        });
                                      },
                                      child: Listener(
                                          onPointerDown: (event) {
                                            setState(() {
                                              copyButtonMargin = 5;
                                              copyButtonHeight = 35;
                                              copyButtonWidth = 170;
                                              copyButtonOffsetBottom = 0;
                                              copyButtonOffsetLeft = 0;
                                            });
                                          },
                                          onPointerUp: (event) {
                                            setState(() {
                                              copyButtonMargin = 0;
                                              copyButtonHeight = 40;
                                              copyButtonWidth = 175;
                                              copyButtonOffsetBottom = 5;
                                              copyButtonOffsetLeft = -5;
                                            });
                                          },
                                          child: Container(
                                              height: copyButtonHeight,
                                              width: copyButtonWidth,
                                              margin: EdgeInsets.fromLTRB(
                                                  copyButtonMargin, 10, 10, 10),
                                              decoration: BoxDecoration(
                                                  color: green,
                                                  border: Border.all(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(
                                                            copyButtonOffsetLeft,
                                                            copyButtonOffsetBottom))
                                                  ]),
                                              alignment: Alignment.center,
                                              child: Text(
                                                text,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ))),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ]),
                )))
              ]))),
    );
  }
}
