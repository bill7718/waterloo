///
/// Contains classes and interfaces needed by the waterloo library which have no flutter
/// dependencies
///
library waterloo_vm;



///
/// Classes that implement this interface provide a simple integer score when provided with a String
///
/// This can be used to filter lists of data by comparing the data content against a String entered by a user.
///
abstract class Scored extends Object {

  final Map<String, int> _cache = <String, int>{};

  ///
  /// Return a score that, in some way, reflects the match between the String provided and
  /// the data content of this object. By convention a higher score indicates a greater match.
  ///
  /// The score method many be called many times for the same object and filter value.
  ///
  int score(String filter);

  ///
  /// Calls the [score] method caching the result so that it does not need to be recomputed next time
  ///
  int getScore(String filter) {
    if (_cache[filter] == null) {
      var value = score(filter);
      _cache[filter] = value;
      return value;
    } else {
      return _cache[filter]!;
    }
  }

  /// This method is added so that we can verify the [clearScoreCache] method
  bool get isCacheEmpty =>_cache.isEmpty;

  /// Clears the cache of scores recorded by the [getScore] method
  void clearScoreCache()=>_cache.clear();
}

abstract class Clone<T> {
  /// Returns a clone of this Object
  T clone();
}

