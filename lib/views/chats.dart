import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key, required this.chatId}) : super(key: key);
  final String? chatId;

  @override
  State<Chats> createState() => _ChatsState(chatId);
}

class _ChatsState extends State<Chats> {
  String? chatId;
  Conversation? conv;

  _ChatsState(this.chatId);

  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  Future<void> makeRequest() async {
    var uri = Uri.parse('http://127.0.0.1:8050/api/v1/conversations/$chatId');
    var response = await http.get(uri);
    requestComplete(response);
  }

  void requestComplete(http.Response response) {
    if (response.statusCode == 200) {
      processResponse(response.body);
    }
  }

  void processResponse(String jsonString) {
    conv = Conversation.fromJSON(json.decode(jsonString));
    setState(() {
      print("State set");
    });
  }

  Widget getMessageCard(Message message) {
    List<Widget> messageChildren = [];
    messageChildren.add(Text(
      message.imDisplayName,
      style: const TextStyle(
        color: Color.fromRGBO(125, 125, 125, 1.0),
        fontWeight: FontWeight.bold,
      ),
    ));

    if (message.subject != null) {
      messageChildren.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
          child: Text(
          message.subject ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      );
    }
    messageChildren.add(
      Html(
        data: message.content,
        style: {"body": Style(margin: EdgeInsets.zero)},
        onLinkTap: (url, context, attributes, element) =>
            {print("Clicked link: $url")},
      ),
    );

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: messageChildren,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (conv != null) {
      for (final message in conv!.messages) {
        if (message.type == "RichText/Html") {
          var card = getMessageCard(message);
          children.add(card);
        } else {
          print("skipping ${message.type}");
        }
      }
      return Scaffold(
          appBar: AppBar(
            title: const Text("Chats"),
          ),
          body: ListView(
            children: [Column(children: children)],
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
        ),
        body: const Center(
          child: Text("Waiting for the messages to load..."),
        ));
  }
}
