import 'package:logger/logger.dart';

class DMLogger extends Logger {

  static final DMLogger _instance = DMLogger._();

  factory DMLogger() {
    return _instance;
  }

  DMLogger._() : super(
    filter: null,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 130,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    output: null,
  );
}