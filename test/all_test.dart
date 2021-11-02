

import 'src/waterloo_theme_test.dart' as theme;
import 'src/waterloo_text_field_test.dart' as text;
import 'src/waterloo_date_field_test.dart' as date;
import 'src/waterloo_currency_field_test.dart' as currency;
import 'src/waterloo_text_button_test.dart' as button;
import 'src/waterloo_switch_tile_test.dart' as switch_tile;
import 'src/waterloo_form_message_test.dart' as form_message;
import 'src/waterloo_drop_down_list_test.dart' as drop;
import 'src/waterloo_future_drop_down_list_test.dart' as future_drop;
import 'src/waterloo_radio_button_list_test.dart' as radio;

import 'src/waterloo_grid_layout_constraints_test.dart' as grid_constraints;


import 'src/change_notifier_list_test.dart' as list;

import 'src/data_object_text_field_test.dart' as data_object_text;
import 'src/data_object_drop_down_list_test.dart' as data_object_drop;
import 'src/data_object_radio_list_test.dart' as data_object_radio;
import 'src/data_object_change_notifier_test.dart' as data_object_change;
import 'src/data_object_currency_field_test.dart' as data_object_currency;
import 'src/data_object_view_test.dart' as data_object_view;
import 'src/data_object_date_field_test.dart' as data_object_date;
import 'src/data_object_integer_field_test.dart' as data_object_integer;
import 'src/data_object_switch_tile_test.dart' as data_object_switch_tile;


main () {

  theme.main();
  text.main();
  date.main();
  currency.main();
  button.main();
  switch_tile.main();
  form_message.main();
  drop.main();
  future_drop.main();
  radio.main();

  list.main();

  grid_constraints.main();

  data_object_text.main();
  data_object_drop.main();
  data_object_radio.main();
  data_object_change.main();
  data_object_currency.main();
  data_object_view.main();
  data_object_date.main();
  data_object_integer.main();
  data_object_switch_tile.main();

}

///
/// you can amend the size of the page with
///
/// tester.binding.window.physicalSizeTestValue = const Size(1024, 768)
///