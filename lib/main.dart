import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'post.dart';
import 'package:http/http.dart' as http;

import 'Screens/login_screen.dart';
import 'global.dart' as global;

void main() async {
  await getJson();
  print(global.jsonData);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      routes: {
        '/': (context) => const MyHomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Post(),
    );
  }
}

getJson() async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'PUT',
      Uri.parse(
          'https://getpantry.cloud/apiv1/pantry/87ab0781-0c05-4027-a519-146e72583196/basket/music_world'));
  request.body = json.encode({
    "name": "Postman_Account_Updated",
    "description": "Postman test account updated"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    global.jsonData = json.decode(await response.stream.bytesToString());
    // print(global.jsonData["ahmadhabibshovo"]["password"]);
  } else {}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
