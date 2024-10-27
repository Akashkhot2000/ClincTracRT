import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/home/model/stud_dashboard_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GetStudDashBoardAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    StudDashboardModel studDashboardModel = StudDashboardModel(
        data: StudDashboardListData(
            attendanceCount: '',
            checkoffCount: '',
            interactionCount: '',
            incidentCount: '',
            journalCount: '',
            procedureCount: '',
            loggedUserDetails: LoggedUserDetails(
              loggedUserEmail: '',
              loggedUserFirstName: '',
              loggedUserLastName: '',
              loggedUserMiddleName: '',
              loggedUserProfile: '',
              loggedUserSchoolImagePath: '',
              loggedUserSchoolName: '',
            )));

    final DataResponseModel dataResponseModel =
        await dataService.getUserDashboardDetails(
          box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,);

    if (dataResponseModel.success) {
      // log(dataResponseModel.data.toString());

      studDashboardModel = StudDashboardModel.fromJson(dataResponseModel.data);
    }

    return state.copy(studDashboardModel: studDashboardModel);
  }
}
