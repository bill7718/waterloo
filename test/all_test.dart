

import 'src/waterloo_theme_test.dart' as theme;
import 'src/waterloo_text_field_test.dart' as text;
import 'src/waterloo_date_field_test.dart' as date;
import 'src/waterloo_currency_field_test.dart' as currency;
import 'src/waterloo_text_button_test.dart' as button;
import 'src/waterloo_switch_tile_test.dart' as switch_tile;
import 'src/waterloo_form_message_test.dart' as form_message;
import 'src/waterloo_drop_down_list_test.dart' as drop;


import 'src/data_object_text_field_test.dart' as data_object_text;

main () {

  theme.main();
  text.main();
  date.main();
  currency.main();
  button.main();
  switch_tile.main();
  form_message.main();
  drop.main();

  data_object_text.main();

}

///
/// you can amend the size of the page with
///
/// tester.binding.window.physicalSizeTestValue = const Size(1024, 768)
///