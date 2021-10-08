import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/waterloo_theme.dart';

class WaterlooFormContainer extends StatelessWidget {
  final GlobalKey formKey;
  final List<Widget> children;

  const WaterlooFormContainer({Key? key, required this.formKey, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Card(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView(children: children)),

        ));
  }
}

class WaterlooAppBar {
  static AppBar get({required String title, String? subtitle, required BuildContext context, Function? handleAction }) => AppBar(
        title: Column ( children: [
          Row(mainAxisAlignment: MainAxisAlignment.center , children: [Text(title), ]),
          if (subtitle != null) Row(mainAxisAlignment: MainAxisAlignment.center , children: [Text(subtitle, style: Provider.of<WaterlooTheme>(context).appBarTheme.subTitleStyle,)])]),
        actions: [ if (handleAction != null) IconButton( icon: Icon(Provider.of<WaterlooTheme>(context).appBarTheme.actionIcon), onPressed: () { handleAction(); },)],
        automaticallyImplyLeading: false,
      );
}

class WaterlooAppBarTheme {

  final IconData actionIcon;
  final TextStyle subTitleStyle;

  const WaterlooAppBarTheme({this.actionIcon =  Icons.home, this.subTitleStyle = const TextStyle(fontSize: 16) });
}


class WaterlooButtonRow extends StatelessWidget {
  final List<Widget> children;

  const WaterlooButtonRow({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 800, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children));
  }
}

class WaterlooLongFormContainer extends StatelessWidget {
  final GlobalKey formKey;
  final List<Widget> children;

  const WaterlooLongFormContainer({Key? key, required this.formKey, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Card(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView(children: children)),
        ));
  }
}
