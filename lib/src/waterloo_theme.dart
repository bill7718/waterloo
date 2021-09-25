import 'data_object_form.dart';
import 'waterloo_text_field.dart';

class WaterlooTheme {
  final WaterlooTextFieldTheme textFieldTheme;
  final DataObjectFormTheme dataObjectFormTheme;

  WaterlooTheme(
      {this.textFieldTheme = const WaterlooTextFieldTheme(), this.dataObjectFormTheme = const DataObjectFormTheme()});
}
