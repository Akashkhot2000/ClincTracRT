import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/homeactions/get_active_rotation_list_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class SetClockInOutAction extends ReduxAction<AppState> {
  SetClockInOutAction({
    required this.rotationID,
    required this.longitude,
    required this.lattitude,
    required this.clockInOutStatus,
    required this.isForActiveRotation,
  });

  final String rotationID;
  final String longitude;
  final String lattitude;
  final ClockInOutStatus clockInOutStatus;
  final bool isForActiveRotation;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.setClockInOROut(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            rotationID,
            longitude,
            lattitude,
            clockInOutStatus == ClockInOutStatus.inn ? "in" : "out");

    if (dataResponseModel.success) {
      if (isForActiveRotation) {
        store.dispatch(GetStudActiveRotationsListAction());
      } else {
        store.dispatch(
            SetRotationsListAction(active_status: state.active_status));
      }
    } else {}

    return state.copy();
  }
}
