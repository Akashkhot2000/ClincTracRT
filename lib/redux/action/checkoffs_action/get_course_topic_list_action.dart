import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/course_topic_list_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO get the child Id
class GetCourseTopicListAction extends ReduxAction<AppState> {
  GetCourseTopicListAction({
    this.rotationId,
  });

  final String? rotationId;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    ///List for the course values
    CourseTopicListModel courseTopicListModel = CourseTopicListModel(data: []);
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getCourseTopicList(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            rotationId!);
    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        courseTopicListModel =
            CourseTopicListModel.fromJson(dataResponseModel.data);

        // log(courseTopicListModel.data.toString());
      } else {}
    } else {}

    return state.copy(courseTopicListModel: courseTopicListModel);
  }
}

class GetAllCourseTopicListAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    ///List for the course values
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CourseTopicListModel allCourseTopicListModel =
        CourseTopicListModel(data: []);
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getAllCourseTopicList(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,);
    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        allCourseTopicListModel =
            CourseTopicListModel.fromJson(dataResponseModel.data);

        // log(allCourseTopicListModel.data.toString());
      } else {}
    } else {}

    return state.copy(allCourseTopicListModel: allCourseTopicListModel);
  }
}
