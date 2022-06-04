import 'package:flutter/cupertino.dart';

class Teams extends StatelessWidget {
  const Teams({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [Column(children: children)]);
  }
}