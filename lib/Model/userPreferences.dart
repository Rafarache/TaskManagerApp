import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get data {
    return _prefs.getInt('data') ?? 1;
  }

  set data(int value) {
    _prefs.setInt('data', value);
  }

  get showPinned {
    return _prefs.getBool('showPinned') ?? false;
  }

  set showPinned(bool value) {
    _prefs.setBool('showPinned', value);
  }
}
