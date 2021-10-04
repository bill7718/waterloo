


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PositionProviderWidget extends StatelessWidget implements PositionProvider {
  final Widget child;
  final GlobalKey positionKey = GlobalKey();

  PositionProviderWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<PositionProvider>.value(value: this, key: positionKey, child: child);
  }

  @override
  double get left => _getOffset().dx;

  @override
  double get top => _getOffset().dy;

  Offset _getOffset() {
    final RenderBox renderBox = positionKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}

abstract class PositionProvider {
  double get top;
  double get left;
}
