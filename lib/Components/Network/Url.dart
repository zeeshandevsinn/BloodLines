abstract class BaseConfig {
  String get apiUrl;
  String get imageUrl;
  String get baseUrl;
  String get socketUrl;
  String get slashImageUrl;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://bloodlines.gologonow.app/";

  @override
  String get imageUrl => "https://bloodlines.gologonow.app";

  @override
  String get slashImageUrl => "https://bloodlines.gologonow.app/";

  @override
  String get apiUrl => "https://bloodlines.gologonow.app/api/";

  @override
  String get socketUrl => "ws://192.168.5.251:8086/cam";

}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "http://apis.bloodlines.info/public/api/";

  @override
    String get imageUrl => "http://apis.bloodlines.info/public";
  @override
  String get slashImageUrl => "http://apis.bloodlines.info/public";

  @override
  String get apiUrl => "http://apis.bloodlines.info/public/api/";

  @override
  String get socketUrl => "ws://apis.bloodlines.info:8088";


// String get mapKey => "AIzaSyDLtchj3AddQGK3mlMgqA6HKbLQlEkEa38";
}
//flutter run --dart-define=ENVIRONMENT=dev

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String production = 'production';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProductionConfig();
      default:
        return DevConfig();
    }
  }
}
