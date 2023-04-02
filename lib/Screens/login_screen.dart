import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/main_controller.dart';
import '../global.dart' as global;
import 'post.dart';
import 'signup_screen.dart';

String? userSID;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final mainController = Get.put(MainController());
  bool clicked = false;

  Future getValidationData() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("user");

    setState(() {
      userSID = userId;
    });
    if (userSID != null) {
      List list = global.jsonData["user"][0];

      for (var element in list) {
        global.userIndex =
            list.indexWhere((element) => element["userName"] == userSID);
        break;
      }
    }
  }

  @override
  void initState() {
    getValidationData().whenComplete(() {
      if (userSID != null) {
        Get.offAll(const Post());
      }
    });
    super.initState();
  }

  bool passwordVisible = true;
  String errorTextVal = '';
  String errorTextPassword = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Music World",
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: GetPlatform.isDesktop ? Get.width / 2 : Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Card(
                  elevation: 50,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              if (value.contains(" ")) {
                                errorTextVal = "Don't use blank Space";
                              } else {
                                errorTextVal = '';
                              }
                            });
                          },
                          controller: _userController,
                          decoration: InputDecoration(
                            errorText: errorTextVal == '' ? null : errorTextVal,
                            prefixIcon: const Icon(Icons.account_circle),
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: "Username",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: (value2) {
                            setState(() {
                              if (value2.contains(" ")) {
                                errorTextPassword = "Don't use blank Space";
                              } else {
                                errorTextPassword = '';
                              }
                            });
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.key),
                            errorText: errorTextPassword == ''
                                ? null
                                : errorTextPassword,
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: "Password",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (clicked == false) {
                            if (_passwordController.text != "" &&
                                _userController.text != '') {
                              bool isUser() {
                                List list = global.jsonData["user"][0];

                                for (var element in list) {
                                  if (element["userName"] ==
                                          _userController.text &&
                                      element["password"] ==
                                          _passwordController.text) {
                                    return true;
                                  }
                                }
                                return false;
                              }

                              if (isUser()) {
                                List list = global.jsonData["user"][0];
                                global.userIndex = list.indexWhere((element) =>
                                    element["userName"] ==
                                    _userController.text);
                                mainController.userLogin();
                              } else {
                                mainController.showErrorDialog(
                                    title: "Wrong",
                                    description: "Wrong username or password");
                              }

                              final prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString(
                                  'user', _userController.text.toString());
                            } else {
                              mainController.showErrorDialog(
                                  title: "Empty",
                                  description: "Enter user name and password");
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Not a member ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const SignupScreen());
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
