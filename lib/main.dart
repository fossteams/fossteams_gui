import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossteams_gui/models/conversations.dart';
import 'package:fossteams_gui/teams.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(
        title: "FossTeams",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> children = [];

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  Future<void> makeRequest() async {
    print("making request");
    var uri = Uri.parse('http://127.0.0.1:8050/api/v1/conversations');
    var response = await http.get(uri);
    requestComplete(response);
  }

  void requestComplete(http.Response response) {
    print("Request Complete!");
    print(response);
    if (response.statusCode == 200) {
      processResponse(response.body);
    }
  }

  Card getCard(String title) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(),
        title: Text(title),
      ),
    );
  }

  void processResponse(String jsonString) {
    var convs = Conversations.fromJSON(json.decode(jsonString));
    for (final team in convs.teams) {
      children.add(getCard(team.displayName));
    }
    setState(() {
      print("State set");
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Teams(
        children: children,
      )),
    );
  }
}
