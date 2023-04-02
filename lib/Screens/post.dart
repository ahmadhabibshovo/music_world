import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/main_controller.dart';
import '../global.dart' as global;
import 'add_post.dart';
import 'login_screen.dart';
import 'public_post.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  List list = global.jsonData["user"][0][global.userIndex]["post"];
  final List<Color> color = [
    const Color(0xff4D455D),
    const Color(0xffE96479),
    const Color(0xff2B3467),
    const Color(0xffFFB562),
    const Color(0xff3AB0FF),
  ];
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
    } else {}
  }

  final _indexController = TextEditingController();
  String errorTextVal = '';
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "LogOut",
                  middleText: "",
                  onConfirm: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove("user");
                    Get.offAll(const LoginScreen());
                  },
                  onCancel: () {});
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.red.shade200,
            )),
        title: const Center(child: Text("Music Qutes")),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.to(const PublicPost());
            },
            icon: const Icon(Icons.group),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(const AddPost());
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: GetPlatform.isDesktop ? Get.width / 2 : Get.width,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  if (index != 0) {
                    Get.defaultDialog(
                      title: "You want to Delete",
                      middleText: "Your post will be delete permanently",
                      onCancel: () {
                        setState(() {});
                      },
                      onConfirm: () {
                        list.removeAt(index);

                        post();
                        setState(() {});
                        Get.back();
                      },
                    );
                  }
                },
                child: InkWell(
                  onLongPress: () {
                    Get.defaultDialog(
                      title: "Share to all",
                      middleText: "All users will see your this post",
                      onCancel: () {},
                      onConfirm: () {
                        global.jsonData["user"][1].add([
                          global.jsonData["user"][0][global.userIndex]
                              ["fullName"],
                          global.jsonData["user"][0][global.userIndex]
                              ["userName"],
                          list[index]
                        ]);
                        post();

                        Get.back();
                      },
                    );
                  },
                  child: Card(
                    color: color[list[index][2]],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        SizedBox(
                                            child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: TextField(
                                                  autofocus: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (int.parse(value) >
                                                          list.length) {
                                                        errorTextVal =
                                                            "Enter number between 1 to ${list.length}";
                                                      } else {
                                                        errorTextVal = '';
                                                      }
                                                    });
                                                  },
                                                  controller: _indexController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    errorText:
                                                        errorTextVal == ''
                                                            ? null
                                                            : errorTextVal,
                                                    prefixIcon:
                                                        const Icon(Icons.list),
                                                    isDense: true,
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: "Move Position",
                                                    hintText:
                                                        "Enter position here",
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        if (int.parse(
                                                                _indexController
                                                                    .text) <=
                                                            list.length) {
                                                          var element = list
                                                              .removeAt(index);
                                                          list.insert(
                                                              int.parse(_indexController
                                                                      .text) -
                                                                  1,
                                                              element);
                                                          post();
                                                          Get.back();
                                                        }
                                                      },
                                                      child: const Text("Ok")),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    );
                                  },
                                );
                              },
                            ).whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (index + 1).toString(),
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 15),
                          child: Text(
                            list[index][1],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: GetPlatform.isDesktop
                                  ? Get.width / 2 * .05
                                  : Get.width * .05,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 10),
                          child: Text(
                            list[index][0],
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: GetPlatform.isDesktop
                                    ? Get.width / 2 * .04
                                    : Get.width * .04,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
