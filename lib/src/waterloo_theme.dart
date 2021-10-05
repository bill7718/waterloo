import 'package:flutter/material.dart';
import 'package:waterloo/src/waterloo_currency_field.dart';
import 'package:waterloo/src/waterloo_date_field.dart';
import 'package:waterloo/beta/waterloo_form_container.dart';

import '../beta/data_object_form.dart';
import '../beta/data_object_table.dart';
import '../beta/waterloo_drop_drown_list.dart';
import '../beta/waterloo_percent_field.dart';
import '../beta/waterloo_switch_tile.dart';
import 'waterloo_text_field.dart';

///
/// Contains theme data that is specific to Waterloo Widgets
/// Use [ThemeData] in preference to these theme parameters.
///
class WaterlooTheme {

  final WaterlooTextFieldTheme textFieldTheme;
  final DataObjectFormTheme dataObjectFormTheme;
  final WaterlooDropDownListTheme waterlooDropDownListTheme;
  final WaterlooSwitchTileTheme switchTileTheme;
  final WaterlooDateFieldTheme dateFieldTheme;
  final WaterlooCurrencyFieldTheme currencyFieldTheme;
  final WaterlooPercentFieldTheme percentFieldTheme;
  final DataObjectTableTheme tableTheme;
  final WaterlooAppBarTheme appBarTheme;

  WaterlooTheme(
      {this.textFieldTheme = const WaterlooTextFieldTheme(),
      this.dataObjectFormTheme = const DataObjectFormTheme(),
      this.waterlooDropDownListTheme = const WaterlooDropDownListTheme(),
      this.switchTileTheme = const WaterlooSwitchTileTheme(),
      this.dateFieldTheme = const WaterlooDateFieldTheme(),
      this.currencyFieldTheme = const WaterlooCurrencyFieldTheme(),
      this.percentFieldTheme = const WaterlooPercentFieldTheme(),
      this.tableTheme = const DataObjectTableTheme(),
      this.appBarTheme = const WaterlooAppBarTheme()});
}
