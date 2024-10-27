import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// TO set the child Id
class getMidtermEvalListAction extends ReduxAction<AppState> {
  getMidtermEvalListAction({
    required this.RecordsPerPage,
    required this.pageNo,
    required this.searchTexteNo,
    required this.rotationId,
  });

  final int pageNo;

  final String searchTexteNo;
  final String RecordsPerPage;

  final String rotationId;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    MidtermEvalList midtermEvalList = MidtermEvalList(data: [], pager: Pager());
    final DataService dataService = locator();

    CommonRequest midtermEvalReq = CommonRequest(
      accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      pageNo: pageNo.toString(),
      RecordsPerPage: RecordsPerPage,
      RotationId: rotationId,
      SearchText: '',
    );

    final DataResponseModel dataResponseModel =
        await dataService.getMidtermEvaluationList(midtermEvalReq);

    if (dataResponseModel.success) {
      // log(dataResponseModel.data.toString() + "getMidtermEvaluationList");
      midtermEvalList = MidtermEvalList.fromJson(dataResponseModel.data);
    }

    return state.copy(midtermEvalList: midtermEvalList);
  }
}
