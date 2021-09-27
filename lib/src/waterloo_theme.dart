import 'package:waterloo/src/waterloo_date_field.dart';

import 'data_object_form.dart';
import 'waterloo_drop_drown_list.dart';
import 'waterloo_switch_tile.dart';
import 'waterloo_text_field.dart';

class WaterlooTheme {
  final WaterlooTextFieldTheme textFieldTheme;
  final DataObjectFormTheme dataObjectFormTheme;
  final WaterlooDropDownListTheme waterlooDropDownListTheme;
  final WaterlooSwitchTileTheme switchTileTheme;
  final WaterlooDateFieldTheme dateFieldTheme;

  WaterlooTheme(
      {this.textFieldTheme = const WaterlooTextFieldTheme(),
        this.dataObjectFormTheme = const DataObjectFormTheme(),
        this.waterlooDropDownListTheme = const WaterlooDropDownListTheme(),
      this.switchTileTheme = const WaterlooSwitchTileTheme(),
        this.dateFieldTheme = const WaterlooDateFieldTheme(),
      });
}
