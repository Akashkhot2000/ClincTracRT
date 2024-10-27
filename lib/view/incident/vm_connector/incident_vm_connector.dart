import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/view/attendanceScreen.dart';
import 'package:clinicaltrac/view/incident/view/incident_rotation_%20screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class IncidentScreenConnector extends StatelessWidget {
  final Rotation? rotation;
  final DailyJournalRoute route;

  IncidentScreenConnector({Key? key, this.rotation, required this.route})
      : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IncidentScreenViewModel>(
      model: IncidentScreenViewModel(),
      builder: (BuildContext context, IncidentScreenViewModel vm) =>
          IncidentScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotation: rotation,
        route: route,
      ),
    );
  }
}

class IncidentScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [IncidentScreenViewModel]
  IncidentScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  IncidentScreenViewModel.build({
    required this.userLoginResponse,
    required this.rotationListStudentJournal,
  }) : super(
          equals: [
            <dynamic>[userLoginResponse, rotationListStudentJournal]
          ],
        );

  @override
  IncidentScreenViewModel fromStore() => IncidentScreenViewModel.build(
        userLoginResponse: state.userLoginResponse,
        rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class DailyRoutingDetails {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DailyRoutingDetails({this.rotation, required this.route});

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute? route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    DailyRoutingDetails data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => IncidentScreenConnector(
        rotation: data.rotation,
        route: data.route!,
      ),
    );
  }
}
