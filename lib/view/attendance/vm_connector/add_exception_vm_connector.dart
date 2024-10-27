import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/view/attendanceScreen.dart';
import 'package:clinicaltrac/view/attendance/view/exceptionScreen.dart';
import 'package:clinicaltrac/view/formative/view/add_formative_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddAttenExceptionConnector extends StatelessWidget {
  AttendanceData attendanceData;
  AddAttenExceptionConnector({Key? key, required this.attendanceData}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddAttendExceptionViewModel>(
      model: AddAttendExceptionViewModel(),
      builder: (BuildContext context, AddAttendExceptionViewModel vm) => ExceptionScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        attendanceData: attendanceData,
        rotationListJournal: vm.rotationListStudentJournal,
        // attendanceData: vm.attendanceDataList,

      ),
    );
  }
}

class AddAttendExceptionViewModel extends BaseModel<AppState> {
  /// Constructor for [AddAttendExceptionViewModel]
  AddAttendExceptionViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  // late AttendanceResponseDart attendanceData;

  //late VoidCallback getAttendance;

  AddAttendExceptionViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal,
    // required this.attendanceData,
  })
      : super(
    equals: [
      <dynamic>[
        userLoginResponse,
      ]
    ],
  );

  @override
  AddAttendExceptionViewModel fromStore() => AddAttendExceptionViewModel.build(
    userLoginResponse: state.userLoginResponse,
    rotationListStudentJournal: state.rotationListStudentJournal,
    // attendanceData: state.attendanceResponseDart,
  );
}

class AddAttendExceptionRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddAttendExceptionRoutingData({
    this.attendanceData,
  });

  /// to load a particular page at initial time
  final AttendanceData? attendanceData;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      AddAttendExceptionRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddAttenExceptionConnector(
        attendanceData: data.attendanceData!,
      ),
    );
  }
}
