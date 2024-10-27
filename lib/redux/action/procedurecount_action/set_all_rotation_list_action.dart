// ignore_for_file: non_constant_identifier_names

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
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class SetAllRotationsListAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    final DataResponseModel dataResponseModel =
    await dataService.getRotations( box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,'');
    AllRotationListModel allRotationListModel = AllRotationListModel.fromJson(dataResponseModel.data);
    return state.copy(allRotationListModel: allRotationListModel);
  }

  // @override
  // Future<AppState> reduce() async {
  //   AllRotationListModel allrotationListModel = AllRotationListModel(
  //       data: AllRotationListData(
  //         allrotationList: [],));
  //
  //   final DataService dataService = locator();
  //   final DataResponseModel dataResponseModel =
  //   await dataService.getAllRotationList(
  //        box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
  //        box.get(Hardcoded.hiveBoxKey)!.accessToken,
  //       '0',);
  //
  //   if (dataResponseModel.success) {
  //     if (dataResponseModel.data.isNotEmpty) {
  //       log(dataResponseModel.data.toString());
  //
  //       allrotationListModel =
  //           AllRotationListModel.fromJson((dataResponseModel.data));
  //
  //       log(allrotationListModel.data.allrotationList.toString());
  //     } else {}
  //   } else {}
  //
  //   return state.copy(allrotationListModel: allrotationListModel);
  // }
}
