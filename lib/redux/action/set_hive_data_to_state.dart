import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:hive_flutter/adapters.dart';

/// TO set the child Id
class SetHiveDataToStateAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();

    UserLoginResponse userLoginResponse = UserLoginResponse(
        data: Data(
            loggedUserId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
            accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
            loggedUserRankTitle: box.get(Hardcoded.hiveBoxKey)!.loggedUserRankTitle,
            loggedUserRole: box.get(Hardcoded.hiveBoxKey)!.loggedUserRole,
            loggedUserFirstName: box.get(Hardcoded.hiveBoxKey)!.loggedUserFirstName,
            loggedUserMiddleName: box.get(Hardcoded.hiveBoxKey)!.loggedUserMiddleName,
            loggedUserLastName: box.get(Hardcoded.hiveBoxKey)!.loggedUserLastName,
            loggedUserEmail: box.get(Hardcoded.hiveBoxKey)!.loggedUserEmail,
            loggedUserProfile: box.get(Hardcoded.hiveBoxKey)!.loggedUserProfile,
            loggedUserSchoolName: box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolName,
            loggedUserSchoolType: box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType,
            loggedUserloginhistoryId: box.get(Hardcoded.hiveBoxKey)!.loggedUserloginhistoryId,
            loggedUserType: box.get(Hardcoded.hiveBoxKey)!.loggedUserType,
            loggedUserRoleType: box.get(Hardcoded.hiveBoxKey)!.loggedUserRoleType,
        ));

    return state.copy(userLoginResponse: userLoginResponse);
  }
}
