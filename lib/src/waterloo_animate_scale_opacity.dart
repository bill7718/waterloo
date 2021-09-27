import 'dart:async';

import 'package:flutter/material.dart';

class WaterlooAnimateScaleOpacity extends StatefulWidget {
  final double initialScale;
  final double initialOpacity;
  final Duration duration;
  final Widget child;

  const WaterlooAnimateScaleOpacity(
      {Key? key, required this.child, this.initialScale = 0.0, this.initialOpacity = 0.0, this.duration = const Duration(milliseconds: 750)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooAnimateScaleOpacityState();
}

class WaterlooAnimateScaleOpacityState extends State<WaterlooAnimateScaleOpacity> {

  double scale = 0.0;
  double opacity = 0.0;

  @override
  void initState() {
    scale = widget.initialScale;
    opacity = widget.initialOpacity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Timer( const Duration(milliseconds: 25), () {
    setState(() {
    scale = 1.0;
    opacity = 1.0;
    });
    });

    return AnimatedScale(scale: scale, duration: widget.duration,
    child: AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      child: widget.child
    ));
  }
}
