import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class getProcedureCountAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    final DataResponseModel dataResponseModel =
    await dataService.getRotations( box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,'');
    AttendanceResponseDart attendanceResponse = AttendanceResponseDart.fromJson(dataResponseModel.data);
    return state.copy(attendanceResponseDart: attendanceResponse);
  }
}




// import 'dart:developer';
//
// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/api/data_locator.dart';
// import 'package:clinicaltrac/api/data_service.dart';
// import 'package:clinicaltrac/model/data_response_model.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
//
// /// TO get the child Id
// class getProcedureCountListAction extends ReduxAction<AppState> {
//   getProcedureCountListAction({
//     required this.rotationId,
//   });
//
//   final String rotationId;
//
//   @override
//   Future<AppState> reduce() async {
//     ///List for the course values
//     ProcedureCountModel procedureCountModel =
//     ProcedureCountModel(data: []);
//     final DataService dataService = locator();
//     final DataResponseModel dataResponseModel =
//     await dataService.getProcedureCountList(
//          box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
//          box.get(Hardcoded.hiveBoxKey)!.accessToken,
//         rotationId);
//     if (dataResponseModel.success) {
//       if (dataResponseModel.data.isNotEmpty) {
//         log(dataResponseModel.data.toString());
//
//         procedureCountModel =
//             ProcedureCountModel.fromJson(dataResponseModel.data);
//
//         log(procedureCountModel.data.toString());
//       } else {}
//     } else {}
//
//     return state.copy(procedureCountModel: procedureCountModel);
//   }
// }
