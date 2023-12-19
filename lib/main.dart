import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:model_http_request/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  List<UserData> allUser = [];
  Future getAllUsers() async {
    try {
      var response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=2"),
      );
      List data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      data.forEach((element) {
        allUser.add(UserData.fromJson(element));
      });
      print(allUser);
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MODEL HTTP REQUEST"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("LOADING ...."),
              );
            } else {
              if (allUser.length == 0) {
                return Center(
                  child: Text("TIDAK ADA DATA"),
                );
              }
              return ListView.builder(
                
                itemCount: allUser.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage("${allUser[index].avatar}"),
                  ),
                  title: Text(
                      "${allUser[index].firstName} ${allUser[index].lastName}"),
                  subtitle: Text("${allUser[index].email}"),
                ),
              );
            }
          }),
    );
  }
}
