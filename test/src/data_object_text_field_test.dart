import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_text_field.dart';
import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  var data = TestDataObject(<String, dynamic>{});

  group('Test DataObjectTextField', () {
    setUp(() {
      data = TestDataObject(<String, dynamic>{});
    });

    testWidgets('Add a DataObjectTextField to a page checking that parameters are passed in correctly for an empty field',
        (WidgetTester tester) async {
      var help = 'help';
      var obscure = true;
      var label = 'Hello';
      var field = 'brian';

      Widget page = MockPage(DataObjectTextField(
        data: data,
        label: label,
        help: help,
        obscure: obscure,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(
          checkTextInputField(label, initialValue: data.get(field), obscure: obscure, readOnly: false, help: MockTextProvider.text(help)),
          true);
    });

    testWidgets('Add a DataObjectTextField to a page checking that parameters are passed in correctly for anfield with a value',
        (WidgetTester tester) async {
      var help = 'help';
      var obscure = false;
      var label = 'Hello';
      var field = 'brian';
      data.set(field, '123');

      Widget page = MockPage(DataObjectTextField(
        data: data,
        label: label,
        help: help,
        obscure: obscure,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(
          checkTextInputField(label, initialValue: data.get(field), obscure: obscure, readOnly: false, help: MockTextProvider.text(help)),
          true);
    });

    testWidgets('When I enter an value the value is updated in the data object ', (WidgetTester tester) async {
      var help = 'help';
      var obscure = false;
      var label = 'Hello';
      var field = 'brian';
      data.set(field, '123');

      Widget page = MockPage(DataObjectTextField(
        data: data,
        label: label,
        help: help,
        obscure: obscure,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'hello ryan');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 'hello ryan');
    });

    testWidgets('When I enter an invalid value the value is updated in the data object and a message is shown ', (WidgetTester tester) async {
      var help = 'help';
      var obscure = false;
      var label = 'Hello';
      var field = 'brian';
      data.set(field, '123');

      Widget page = MockPage(DataObjectTextField(
        data: data,
        label: label,
        help: help,
        obscure: obscure,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'hi');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 'hi');
      expect(find.text(MockTextProvider.text('badBrian') ?? ''), findsOneWidget);
    });

    testWidgets('When I provide my own validator this is applied ', (WidgetTester tester) async {
      var help = 'help';
      var obscure = false;
      var label = 'Hello';
      var field = 'brian';
      data.set(field, '123');

      Widget page = MockPage(DataObjectTextField(
        data: data,
        label: label,
        help: help,
        obscure: obscure,
        fieldName: field,
        validator: (v) {
          if (v == 'bye') {
            return 'notBye';
          }
        },
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'bye');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 'bye');
      expect(find.text(MockTextProvider.text('notBye') ?? ''), findsOneWidget);
    });
  });
}

class TestDataObject extends DataObject {
  TestDataObject(Map<String, dynamic> data) : super(data);

  @override
  String? validate({List<String>? fields}) {
    if (fields?.contains('brian') ?? false) {
      if (get('brian') == 'hi') {
        return 'badBrian';
      }
    }
    return null;
  }
}
