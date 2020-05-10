import 'package:shared_preferences/shared_preferences.dart';

class BaseSharePre {}

class SharePre extends BaseSharePre {
  SharedPreferences sharedPreferences;

  get instance async => await SharedPreferences.getInstance();
}
