

import 'src/waterloo_theme_test.dart' as theme;
import 'src/waterloo_text_field_test.dart' as text;
import 'src/waterloo_date_field_test.dart' as date;
import 'src/waterloo_currency_field_test.dart' as currency;
import 'src/waterloo_text_button_test.dart' as button;
import 'src/waterloo_switch_tile_test.dart' as switch_tile;


import 'src/data_object_text_field_test.dart' as data_object_text;

main () {

  theme.main();
  text.main();
  date.main();
  currency.main();
  button.main();
  switch_tile.main();

  data_object_text.main();

}