import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/main_controller.dart';
import '../global.dart' as global;

class PublicPost extends StatefulWidget {
  const PublicPost({super.key});

  @override
  State<PublicPost> createState() => _PublicPostState();
}

class _PublicPostState extends State<PublicPost> {
  List list = global.jsonData["user"][1];
  final List<Color> color = [
    const Color(0xff4D455D),
    const Color(0xffE96479),
    const Color(0xff2B3467),
    const Color(0xffFFB562),
    const Color(0xff3AB0FF),
  ];

  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.red.shade200,
            )),
        title: const Center(child: Text("Music Qutes")),
      ),
      body: Center(
        child: SizedBox(
          width: GetPlatform.isDesktop ? Get.width / 2 : Get.width,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Card(
                color: color[list[index][2][2]],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 15),
                      child: Row(children: [
                        const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        Column(
                          children: [
                            Text(
                              list[index][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              list[index][1],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Text(
                        list[index][2][1],
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
                        list[index][2][0],
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
              );
            },
          ),
        ),
      ),
    );
  }
}
