import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class FilterRotationListByCourse extends ReduxAction<AppState> {
  FilterRotationListByCourse({
    required this.active_status,
    required this.courseId,
    required this.searchText,
  });

  final Active_status active_status;

  final String courseId;

  final String searchText;
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    RotationListModel rotationListModel = RotationListModel(
        data: RotaionListData(isClockedIn: false, rotationList: [],pendingRotation: []),pager: Pager());

    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getRotationListByCourse(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            '1',
            active_status == Active_status.active ? "0" : "1",
            courseId,
            searchText);

    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        rotationListModel =
            RotationListModel.fromJson((dataResponseModel.data));

        if (rotationListModel.data.rotationList!.isEmpty) {}

        // log(rotationListModel.data.rotationList.toString());
      } else {}
    } else {}

    return state.copy(rotationListModel: rotationListModel);
  }
}


/// TO set the child Id
class FilterRotationListByCourseList extends ReduxAction<AppState> {
  FilterRotationListByCourseList({
    required this.active_status,
    required this.courseId,
    required this.searchText,
  });

  final String active_status;

  final String courseId;

  final String searchText;
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    RotationListModel rotationListModel = RotationListModel(
        data: RotaionListData(isClockedIn: false, rotationList: [],pendingRotation: []),pager: Pager());

    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
    await dataService.getRotationListByCourse(
         box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
         box.get(Hardcoded.hiveBoxKey)!.accessToken,
        '1',
        active_status == "active" ? "0" : "1",
        courseId,
        searchText);

    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        rotationListModel =
            RotationListModel.fromJson((dataResponseModel.data));

        if (rotationListModel.data.rotationList!.isEmpty) {}

        // log(rotationListModel.data.rotationList.toString());
      } else {}
    } else {}

    return state.copy(rotationListModel: rotationListModel);
  }
}
