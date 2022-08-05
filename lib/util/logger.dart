import 'package:logger/logger.dart';

class Log {
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]){
    final logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
          printTime: true,
        )
    );

    logger.d(message, error, stackTrace);
  }
}