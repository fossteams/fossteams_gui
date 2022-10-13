import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossteams_gui/models/conversations.dart';
import 'package:fossteams_gui/teams.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Conversations? convs;

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

  Card getTeamCard(Team team) {
    return Card(
      child: ListTile(
        leading: const FlutterLogo(),
        title: Text(team.displayName),
        onTap: () => context.push(context.namedLocation('chats', params: <String, String>{'chatId': team.id})),
      ),
    );
  }

  void processResponse(String jsonString) {
    convs = Conversations.fromJSON(json.decode(jsonString));
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if(convs != null) {
      for (final team in convs!.teams) {
        var card = getTeamCard(team);
        children.add(card);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Teams(
          children: children,
        ),
      ),
    );
  }
}
