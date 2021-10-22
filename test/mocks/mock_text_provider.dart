

import 'package:waterloo/src/waterloo_text_provider.dart';

class MockTextProvider extends WaterlooTextProvider {
  @override
  String? get(String? reference) => reference == null ? null : 'lookup_$reference';

  static String? text(String? reference) => reference == null ? null : 'lookup_$reference';

  @override
  bool has(String? reference)=>true;
}