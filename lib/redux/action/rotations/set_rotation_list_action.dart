// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class SetRotationsListAction extends ReduxAction<AppState> {
  SetRotationsListAction({
    required this.active_status,
  });

  final Active_status active_status;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    RotationListModel rotationListModel = RotationListModel(
        data: RotaionListData(
            isClockedIn: false,
            rotationList: [],
            pendingRotation:[]),pager: Pager());

    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getRotationList(
           box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            '0',
            active_status == Active_status.active ? "0" : "1");

    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        rotationListModel =
            RotationListModel.fromJson((dataResponseModel.data));

        // log(rotationListModel.data.rotationList.toString());
      } else {}
    } else {}

    return state.copy(rotationListModel: rotationListModel);
  }
}
