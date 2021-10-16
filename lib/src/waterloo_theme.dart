import 'package:flutter/material.dart';
import 'package:waterloo/beta/data_object_view.dart';
import 'package:waterloo/beta/waterloo_grid.dart';
import 'package:waterloo/beta/waterloo_journey_scaffold.dart';
import 'package:waterloo/src/waterloo_currency_field.dart';
import 'package:waterloo/src/waterloo_date_field.dart';
import 'package:waterloo/beta/waterloo_form_container.dart';
import 'package:waterloo/src/waterloo_form_message.dart';

import '../beta/data_object_form.dart';
import '../beta/data_object_table.dart';
import 'waterloo_drop_down_list.dart';
import '../beta/waterloo_percent_field.dart';
import 'waterloo_switch_tile.dart';
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
  final WaterlooGridTheme gridTheme;
  final WaterlooFormMessageTheme formMessageTheme;
  final WaterlooJourneyScaffoldTheme scaffoldTheme;
  final DataObjectViewTheme viewTheme;

  WaterlooTheme({
    this.textFieldTheme = const WaterlooTextFieldTheme(),
    this.dataObjectFormTheme = const DataObjectFormTheme(),
    this.waterlooDropDownListTheme = const WaterlooDropDownListTheme(),
    this.switchTileTheme = const WaterlooSwitchTileTheme(),
    this.dateFieldTheme = const WaterlooDateFieldTheme(),
    this.currencyFieldTheme = const WaterlooCurrencyFieldTheme(),
    this.percentFieldTheme = const WaterlooPercentFieldTheme(),
    this.tableTheme = const DataObjectTableTheme(),
    this.appBarTheme = const WaterlooAppBarTheme(),
    this.gridTheme = const WaterlooGridTheme(),
    this.formMessageTheme = const WaterlooFormMessageTheme(),
    this.scaffoldTheme = const WaterlooJourneyScaffoldTheme(),
    this.viewTheme = const DataObjectViewTheme(),
  });
}
