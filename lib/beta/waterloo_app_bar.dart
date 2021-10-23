import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/waterloo_theme.dart';


class WaterlooAppBar {
  static AppBar get({required String title, String? subtitle, required BuildContext context, Function? handleAction, Function? handleAction2}) => AppBar(
        title: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title),
          ]),
          if (subtitle != null)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                subtitle,
                style: Provider.of<WaterlooTheme>(context).appBarTheme.subTitleStyle,
              )
            ])
        ]),
        actions: [
          if (handleAction != null)
            IconButton(
              icon: Icon(Provider.of<WaterlooTheme>(context).appBarTheme.actionIcon),
              onPressed: () {
                handleAction();
              },
            ),
          if (handleAction2 != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                handleAction2();
              },
            ),
        ],
        automaticallyImplyLeading: false,
      );
}

class WaterlooAppBarTheme {
  final IconData actionIcon;
  final TextStyle subTitleStyle;

  const WaterlooAppBarTheme({this.actionIcon = Icons.home, this.subTitleStyle = const TextStyle(fontSize: 16)});
}
