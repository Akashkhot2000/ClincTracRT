import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class GetStudActiveRotationsListAction extends ReduxAction<AppState> {
  // GetStudActiveRotationsListAction();

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    ActiveRotationListModel activeRotationListModel = ActiveRotationListModel(
        data: ActiveRotaionListData(
            isClockedIn: false, rotationList: [], pendingRotation: []));

    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getStudActiveRotationList(
       box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
       box.get(Hardcoded.hiveBoxKey)!.accessToken,
    );

    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log("////////////////" + dataResponseModel.data.toString());

        activeRotationListModel =
            ActiveRotationListModel.fromJson((dataResponseModel.data));

        // log(activeRotationListModel.data.rotationList.toString());
      } else {}
    } else {}

    return state.copy(activeRotationListModel: activeRotationListModel);
  }
}
