// import 'dart:developer';
//
// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/api/data_locator.dart';
// import 'package:clinicaltrac/api/data_service.dart';
// import 'package:clinicaltrac/model/data_response_model.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/home/model/dashBoard_data.dart';
//
// /// TO set the child Id
// class GetUserDashBoardAction extends ReduxAction<AppState> {
//   @override
//   Future<AppState> reduce() async {
//     final DataService dataService = locator();
//
//     UserDashBoardModel userDashBoardModel = UserDashBoardModel(
//         data: DashBoardData(
//             interactionCount: '',
//             checkoffCount: '',
//             journalCount: '',
//             procedureCount: '',
//             incidentCount: '',
//             attendanceCount: '',
//             interactionAvgCount: 0,
//             journalAvgCount: 0,
//             procedureAvgCount: 0,
//             attendanceAvgCount: 0,
//             loggedUserDetails: []));
//
//     final DataResponseModel dataResponseModel =
//         await dataService.getUserDashboardDetails(
//              box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
//              box.get(Hardcoded.hiveBoxKey)!.accessToken,);
//
//     if (dataResponseModel.success) {
//       log(dataResponseModel.data.toString());
//
//       userDashBoardModel = UserDashBoardModel.fromJson(dataResponseModel.data);
//     }
//
//     return state.copy(userDashBoardModel: userDashBoardModel);
//   }
// }
