import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CfgEnvironment {
  static String get filename {
    return kReleaseMode ? '.env.production' : '.env.development';
  }

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'urlNotFound';
  }

  static String get localUrl {
    return dotenv.env['LOCAL_URL'] ?? 'urlNotFound';
  }

  static String get googleAPIKey {
    print(dotenv.env['API_KEY'] ?? 'APINotFound');
    return dotenv.env['API_KEY'] ?? 'APINotFound';
  }
}
