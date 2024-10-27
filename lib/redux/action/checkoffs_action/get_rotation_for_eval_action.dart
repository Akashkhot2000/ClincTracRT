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
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO get the child Id
class GetRotationForEvalListAction extends ReduxAction<AppState> {
  GetRotationForEvalListAction({
   this.isAdvanceCheckoff,
  });

  final String? isAdvanceCheckoff;
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    ///List for the course values
    RotationForEvalListModel rotationForEvalListModel =
        RotationForEvalListModel(data: []);
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getRotationForEvalList(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            isAdvanceCheckoff!,
        );
    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        rotationForEvalListModel =
            RotationForEvalListModel.fromJson(dataResponseModel.data);

        // log(rotationForEvalListModel.data.toString());
      } else {}
    } else {}

    return state.copy(rotationForEvalListModel: rotationForEvalListModel);
  }
}
