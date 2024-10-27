import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';

/// change homepage and send callback to body switcher
typedef ChangeScreen = void Function(Bottom_navigation_control pageChange);

///Set userLoginResponse
typedef SetUserLoginResponse =  void Function(UserLoginResponse userLoginResponse);
