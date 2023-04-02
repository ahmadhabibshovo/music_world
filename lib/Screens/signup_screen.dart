import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/main_controller.dart';
import '../global.dart' as global;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final mainController = Get.put(MainController());
  bool _clicked = false;
  bool _user = false;
  post() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://getpantry.cloud/apiv1/pantry/87ab0781-0c05-4027-a519-146e72583196/basket/music_world'));
    request.body = json.encode(global.jsonData);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      global.userIndex = global.jsonData["user"][0]
          .indexWhere((element) => element["userName"] == _userController.text);

      mainController.userLogin();
    } else {}
  }

  String errorTextUser = '';
  String errorTextPass = '';
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Card(
                  elevation: 50,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          autofocus: true,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.accessibility_new),
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "Full Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              if (value.contains(" ")) {
                                errorTextUser = "Don't use blank Space";
                              } else {
                                errorTextUser = '';
                              }
                            });
                          },
                          controller: _userController,
                          decoration: InputDecoration(
                            errorText:
                                errorTextUser == '' ? null : errorTextUser,
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
                          onChanged: (value) {
                            setState(() {
                              if (value.contains(" ")) {
                                errorTextPass = "Don't use blank Space";
                              } else {
                                errorTextPass = '';
                              }
                            });
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                            errorText:
                                errorTextPass == '' ? null : errorTextPass,
                            prefixIcon: const Icon(Icons.key),
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: "Password",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _user = false;
                          if (_clicked == false &&
                              _passwordController.text != "" &&
                              _userController.text != '' &&
                              _nameController.text != '' &&
                              !_passwordController.text.contains(" ") &&
                              !_userController.text.contains(" ")) {
                            List list = global.jsonData["user"][0];

                            for (var element in list) {
                              if (element["userName"] == _userController.text) {
                                _user = true;
                                break;
                              }
                            }

                            if (!_user) {
                              mainController.userLogin();
                              _clicked = true;
                              global.jsonData["user"][0].add({
                                "userName": _userController.text,
                                "fullName": _nameController.text,
                                "password": _passwordController.text,
                                "post": [
                                  [
                                    "আমার সোনার বাংলা",
                                    '''আমার সোনার বাংলা,
আমি তোমায় ভালোবাসি
জন্ম দিয়েছো তুমি মাগো,
তাই তোমায় ভালোবাসি।''',
                                    1
                                  ]
                                ],
                              });
                              global.loggedINUser = _userController.text;
                              global.userIndex = global.jsonData["user"][0]
                                  .indexWhere((element) =>
                                      element["userName"] ==
                                      global.loggedINUser);
                              post();
                              final prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString(
                                  'user', _userController.text.toString());
                            } else {
                              mainController.showErrorDialog(
                                  title: "Username Taken",
                                  description: "Try Other Username or Login");
                            }
                          } else {
                            mainController.showErrorDialog(
                                title: "Empty",
                                description: "Enter user, name and password");
                          }
                        },
                        child: const Text(
                          "SignUp",
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
                              "Already a member ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Text(
                                "Login",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
