

import 'package:waterloo/beta/waterloo_text_provider.dart';

class MockTextProvider extends WaterlooTextProvider {
  @override
  String? get(String? reference) => reference == null ? null : 'lookup_$reference';

}