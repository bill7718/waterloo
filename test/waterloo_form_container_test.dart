
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_form_container.dart';

import 'util.dart';

void main() {



 testWidgets('Add a WaterlooFormContainer to a page', (WidgetTester tester) async {

   var formKey = GlobalKey();

    Widget page = MockPage(
      WaterlooFormContainer(formKey: formKey, children: const <Widget>[],
    ));

    await tester.pumpWidget(page);

  });

 testWidgets('Add a WaterlooFormContainer to a page with lots of text widgets', (WidgetTester tester) async {

   var formKey = GlobalKey();

   var widgets = <Widget>[];
   while (widgets.length < 125) {
     widgets.add(const Text('Hello'));
   }

   Widget page = MockPage(
       WaterlooLongFormContainer(formKey: formKey, children: widgets,
     ));

   await tester.pumpWidget(page);

 });

/*
 testWidgets('Add an AppBar from  WaterlooAppBar to a page', (WidgetTester tester) async {

   Widget page = MockPage(
     WaterlooAppBar.get(title: 'Hello')
     );

   await tester.pumpWidget(page);
   expect(find.text('Hello'), findsOneWidget);

 });

 */

 testWidgets('Add a  WaterlooButtonRow to a page', (WidgetTester tester) async {

   Widget page = const MockPage(
    WaterlooButtonRow(children: [Text('hi')],)
   );

   await tester.pumpWidget(page);
   expect(find.text('hi'), findsOneWidget);

 });


}




