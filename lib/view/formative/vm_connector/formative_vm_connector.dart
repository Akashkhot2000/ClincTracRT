import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/view/attendanceScreen.dart';
import 'package:clinicaltrac/view/formative/view/formative_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class FormativeConnector extends StatelessWidget {
  Rotation rotation;
  final DailyJournalRoute route;
  FormativeConnector({Key? key, required this.rotation, required this.route}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FormativeViewModel>(
      model: FormativeViewModel(),
      builder: (BuildContext context, FormativeViewModel vm) => FormativeScreen(
          //pageChange: pageChange,
          userLoginResponse: vm.userLoginResponse,
          rotation: rotation,
        route: route,
          // rotationListStudentJournal: vm.rotationListStudentJournal,
          ),
    );
  }
}

class FormativeViewModel extends BaseModel<AppState> {
  /// Constructor for [FormativeViewModel]
  FormativeViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  //late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  FormativeViewModel.build({
    required this.userLoginResponse,
    //required this.rotationListStudentJournal,
  }) : super(
          equals: [
            <dynamic>[
              userLoginResponse,
            ]
          ],
        );

  @override
  FormativeViewModel fromStore() => FormativeViewModel.build(
        userLoginResponse: state.userLoginResponse,
        // rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class FormativeRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  FormativeRoutingData({
    this.rotation,
    required this.route,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    FormativeRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => FormativeConnector(
        rotation: data.rotation!,
        route: data.route!,
      ),
    );
  }
}
