import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';

class WaterlooJourneyScaffold extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool act;
  final Widget child;
  final GlobalKey formKey;
  final WaterlooEventHandler eventHandler;

  const WaterlooJourneyScaffold(
      {Key? key, required this.eventHandler, required this.formKey, required this.title, this.subTitle, this.act = true, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WaterlooAppBar.get(
            title: Provider.of<WaterlooTextProvider>(context, listen: false).get(title) ?? '',
            context: context,
            subtitle: Provider.of<WaterlooTextProvider>(context, listen: false).get(subTitle) ?? '',
            handleAction: act
                ? () {
                    eventHandler.handleEvent(context, event: 'home');
                  }
                : null),
        body: Form(
            key: formKey,
            child: Card(
              margin: Provider.of<WaterlooTheme>(context, listen: false).scaffoldTheme.margin,
              child: Container(
                  margin: Provider.of<WaterlooTheme>(context, listen: false).scaffoldTheme.margin,
                  child: SingleChildScrollView(child: child)),
            )));
  }
}

/// Parameters for the display of the  WaterlooJourneyScaffold
class WaterlooJourneyScaffoldTheme {
  /// If provided then override the default margin around this widget
  final EdgeInsets margin;
  final String appBarEvent;

  const WaterlooJourneyScaffoldTheme({this.margin = const EdgeInsets.fromLTRB(20, 20, 20, 20), this.appBarEvent = 'home'});
}
