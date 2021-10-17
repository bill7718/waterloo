library show_coverage;

import 'dart:io';

var fullCoverageExpected = <String>{
  'waterloo_drop_down_list.dart',
  'waterloo_theme.dart',
  'waterloo_text_field.dart',
  'waterloo_date_field.dart',
  'waterloo_currency_field.dart',
  'waterloo_text_button.dart',
  'waterloo_switch_tile.dart',
  'data_object_text_field.dart',
  'waterloo_form_message.dart',
  'data_object_drop_down_list.dart',
  'change_notifier_list.dart',
  'data_object_change_notifier.dart',
  'data_object_currency_field.dart',
  'data_object_view.dart'
};

void main() {

  var codeFiles = <String>{};
  codeFiles.addAll(fullCoverageExpected);

  var file = File('coverage/lcov.info');
  var lines = file.readAsLinesSync();
  var source = '';
  var codeLines = 0;
  var testedLines = 0;

  for (var line in lines) {
    if (line.startsWith('SF:lib')) {
      source = line.split('\\').last;
      codeLines = 0;
      testedLines = 0;
    }

    if (line.startsWith('LF')) {
      codeLines = int.parse(line.split(':').last);
    }

    if (line.startsWith('LH')) {
      testedLines = int.parse(line.split(':').last);

      if (codeLines == testedLines) {
        codeFiles.remove(source);
      }
    }
  }


  if (codeFiles.isEmpty) {
    print('Code Coverage complete');
  } else {
    throw Exception('Code coverage incomplete for ${codeFiles.toString()} ');
  }

}