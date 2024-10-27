import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';


/// TO get the child Id
class GetClinicianListAction extends ReduxAction<AppState> {
  GetClinicianListAction({
    required this.rotationId,
  });

  final String rotationId;

  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    ///List for the course values
    ClinicianDataList clinicianDataList = ClinicianDataList(data: []);
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getClinicianList(
             box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,
            rotationId);
    if (dataResponseModel.success) {
      if (dataResponseModel.data.isNotEmpty) {
        // log(dataResponseModel.data.toString());

        clinicianDataList = ClinicianDataList.fromJson(dataResponseModel.data);

        // log(clinicianDataList.data.toString());
      } else {}
    } else {}

    return state.copy(clinicianDataList: clinicianDataList);
  }
}
