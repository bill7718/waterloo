import 'package:flutter/material.dart';

class Headline6 extends StatelessWidget {
  final String text;

  const Headline6(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class Headline5 extends StatelessWidget {
  final String text;

  const Headline5(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
