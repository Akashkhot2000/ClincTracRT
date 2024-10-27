import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class getDrInteractions extends ReduxAction<AppState> {
  getDrInteractions({
    required this.searchText,
    required this.rotationId,
    this.page,
  });

  final String searchText;

  final String rotationId;

  final int? page;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    StudentDrInteractionData drInteractionList = StudentDrInteractionData(data: DrInteractionData(interactionDescriptionCount: '',interactionList: []),pager: Pager());

    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getDrInterations(
           box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            page.toString(),
            searchText,
            rotationId);

    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        drInteractionList = StudentDrInteractionData.fromJson(dataResponseModel.data);

        // log(drInteractionList.data.toString());
      } else {}
    } else {}

    // log(drInteractionList.data.length.toString() +"drInteractionList Length  at action");

    return state.copy(drInteractionList: drInteractionList);
  }
}
