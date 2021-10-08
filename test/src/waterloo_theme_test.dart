
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';
import '../util.dart';

void main() {

 group('Test WaterlooTheme', () {
   testWidgets('Add a WaterlooTheme to a page via a Provider', (WidgetTester tester) async {
     WaterlooTheme? theme;
     Widget page = MockPage(
       LayoutBuilder( builder: (context, constraints) {
         theme = Provider.of<WaterlooTheme>(context);
         return Container();
       }));
     await tester.pumpWidget(page);
     expect(theme == null, false);
     expect(theme?.textFieldTheme.margin.top, 5);
   });
 });
}