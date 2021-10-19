import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_drop_down_list.dart';
import 'package:waterloo/src/waterloo_radio_button_list.dart';

import '../util.dart';

void main() {
  group('Test Getting a position', () {
    setUp(() {});

    testWidgets('Add a Widget and see if you can get it' 's position', (WidgetTester tester) async {

      var key = GlobalKey();

      Widget page = MockPage(Container(key: GlobalKey(), child: Text('hello', key: GlobalKey())),
      key: key,);
      await tester.pumpWidget(page);

      var box = key.currentContext?.findRenderObject() as RenderBox;
      print(box.size);
      print(box.localToGlobal(Offset.zero));

      print((key.currentWidget as MockPage).child.runtimeType);


    });
  });
}
