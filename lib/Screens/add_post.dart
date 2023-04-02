import 'dart:convert';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Controller/main_controller.dart';
import '../global.dart' as global;

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

int? value = 0;

class _AddPostState extends State<AddPost> {
  final List<Color> color = [
    const Color(0xff4D455D),
    const Color(0xffE96479),
    const Color(0xff2B3467),
    const Color(0xffFFB562),
    const Color(0xff3AB0FF),
  ];
  final mainController = Get.put(MainController());
  // post() async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           'https://getpantry.cloud/apiv1/pantry/87ab0781-0c05-4027-a519-146e72583196/basket/music_world'));
  //   request.body = json.encode({
  //     "user": [
  //       {
  //         "user": "ahmadhabibshovo",
  //         "fullName": "Ahmad Habib",
  //         "password": "lmusic",
  //         "post": {},
  //       },
  //       {
  //         "user": "ahmadhabibshovo",
  //         "fullName": "Ahmad Habib",
  //         "password": "lmusic",
  //         "post": {},
  //       }
  //     ]
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  final _lyricsController = TextEditingController();

  final _nameController = TextEditingController();
  bool _clicked = false;
  post() async {
    mainController.userLogin();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Add "),
      ),
      body: Center(
        child: SizedBox(
          width: GetPlatform.isDesktop ? Get.width / 2 : Get.width,
          child: Column(
            children: [
              Card(
                color: color[value!],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 15),
                      child: AutoSizeTextField(
                        controller: _lyricsController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: GetPlatform.isDesktop
                              ? Get.width / 2 * .05
                              : Get.width * .05,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Lyrics",
                          hintStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, right: 10),
                      child: AutoSizeTextField(
                        controller: _nameController,
                        style: TextStyle(
                          fontSize: GetPlatform.isDesktop
                              ? Get.width / 2 * .04
                              : Get.width * .04,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Song Name"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  5,
                  (int index) {
                    return FilterChip(
                      backgroundColor: color[index],
                      selectedColor: color[index],
                      label: const Text("      "),
                      selected: value == index,
                      onSelected: (bool selected) {
                        setState(() {
                          value = selected ? index : 0;
                        });
                      },
                    );
                  },
                ).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (_clicked == false &&
                      _lyricsController.text != '' &&
                      _nameController.text != '') {
                    _clicked = true;
                    global.jsonData["user"][0][global.userIndex]["post"].add(
                        [_nameController.text, _lyricsController.text, value!]);

                    post();
                  } else {
                    mainController.showErrorDialog(
                        title: "Empty",
                        description: "song name or lyrics is empty");
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '''Add Lyrics''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .04,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
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
