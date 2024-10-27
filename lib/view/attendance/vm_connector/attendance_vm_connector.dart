import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/view/attendanceScreen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AttedanceScreenConnector extends StatelessWidget {
  AttedanceScreenConnector({
    Key? key,
  }) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AttedanceScreenViewModel>(
      model: AttedanceScreenViewModel(),
      builder: (BuildContext context, AttedanceScreenViewModel vm) =>
          AttendanceScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotationListStudentJournal: vm.rotationListStudentJournal,
      ),
    );
  }
}

class AttedanceScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [AttedanceScreenViewModel]
  AttedanceScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late AttendanceResponseDart attendanceResponse;
  late VoidCallback getAttendance;

  AttedanceScreenViewModel.build(
      {required this.userLoginResponse,
      required this.rotationListStudentJournal,
      required this.attendanceResponse,
      required this.getAttendance})
      : super(
          equals: [
            <dynamic>[
              userLoginResponse,
              rotationListStudentJournal,
              attendanceResponse
            ]
          ],
        );

  @override
  AttedanceScreenViewModel fromStore() => AttedanceScreenViewModel.build(
      userLoginResponse: state.userLoginResponse,
      rotationListStudentJournal: state.rotationListStudentJournal,
      attendanceResponse: state.attendanceResponseDart,
      getAttendance: () => store.dispatch(getAttedanceAction()));
}

// class DailyRoutingData {
//   /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
//   DailyRoutingData({this.rotation, required this.route});

//   /// to load a particular page at initial time
//   final Rotation? rotation;
//   final AttedanceRoute? route;

//   /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
//   static MaterialPageRoute<dynamic> resolveRoute(
//     DailyRoutingData data,
//     RouteSettings settings,
//   ) {
//     return MaterialPageRoute<dynamic>(
//       settings: settings,
//       builder: (BuildContext context) => AttedanceScreenConnector(
//         rotation: data.rotation,
//         route: data.route!,
//       ),
//     );
//   }
// }
