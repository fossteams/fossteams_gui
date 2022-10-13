import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fossteams_gui/views/chats.dart';
import 'package:fossteams_gui/views/home.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(FossTeamsApp());
}

class FossTeamsApp extends StatelessWidget {
  FossTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MyHomePage(
            title: "Hello",
          ),
        ),
        routes: [GoRoute(
          name: 'chats',
          path: 'chats/:chatId',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: Chats(chatId: state.params['chatId']),
          ),
        )]
      ),
    ],
  );
}

class AppContainer extends StatelessWidget {
  final String title;
  final Widget innerWidget;

  const AppContainer({Key? key, required this.title, required this.innerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: innerWidget,
    );
  }
}
