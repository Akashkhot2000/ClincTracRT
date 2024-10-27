import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class SetCourseListAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    List<String> courseNameList = [];

    ///List for the course values
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.getCourseList(
       box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
    );

    CourseListModel courseListmodel;

    if (dataResponseModel.success) {
      // log(dataResponseModel.data.toString());
      courseListmodel = CourseListModel.fromJson(dataResponseModel.data);
    } else {
      courseListmodel = CourseListModel(data: []);
    }

    return state.copy(courseListModel: courseListmodel);
  }
}
