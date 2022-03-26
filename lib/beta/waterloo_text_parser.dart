


class WaterlooTextParser {

  static const String start = '{{';
  static const String end = '}}';

  ///
  /// Substitute parameters into template
  ///
  String parse(String template, Map<String, dynamic> parameters) {

    var response = template;

    for (var key in parameters.keys) {
      response = response.replaceAll('$start${key.toString()}$end', parameters[key].toString());
    }
    return response;
  }

}