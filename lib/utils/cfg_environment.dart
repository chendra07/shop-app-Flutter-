import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CfgEnvironment {
  static String get filename {
    return kReleaseMode ? '.env.production' : '.env.development';
  }

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'urlNotFound';
  }
}
