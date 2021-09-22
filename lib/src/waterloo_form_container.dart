import 'package:flutter/material.dart';

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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
        ));
  }
}

class WaterlooAppBar {
  static AppBar get({required String title}) => AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      );
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
