import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHandler{
  static UserLoginResponseHive? getUserData(){
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return box.get(Hardcoded.hiveBoxKey);
  }
}