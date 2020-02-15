typedef DataParser<T> = T Function(Map<String, dynamic> json);

class DataParserFactory {
  final Map<Type, DataParser> decodersMap = Map();

  T decode<T>(Map<String, dynamic> json) {
    try {
      final decoder = decodersMap[T];
      return decoder(json);
    } on Exception catch (_) {
      return null;
    }
  }

  void registerDecoder<T>(DataParser<T> decoder) {
    decodersMap[T] = decoder;
  }

  // instance
  static DataParserFactory _instance = DataParserFactory();
  static DataParserFactory get() => _instance;
}
