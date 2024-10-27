import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/summative/view/summative_screen.dart';

import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class SummativeConnector extends StatelessWidget {
  Rotation rotation;
  final DailyJournalRoute route;
  SummativeConnector({Key? key, required this.rotation,required this.route}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SummativeViewModel>(
        model: SummativeViewModel(),
        builder: (BuildContext context, SummativeViewModel vm) => SummativeScreen(userLoginResponse: vm.userLoginResponse, rotation: rotation,route:route)
        // SummativeScreen(
        //     //pageChange: pageChange,
        //     userLoginResponse: vm.userLoginResponse,
        //     rotation: rotation
        //     // rotationListStudentJournal: vm.rotationListStudentJournal,
        //     ),
        );
  }
}

class SummativeViewModel extends BaseModel<AppState> {
  /// Constructor for [SummativeViewModel]
  SummativeViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  //late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  SummativeViewModel.build({
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
  SummativeViewModel fromStore() => SummativeViewModel.build(
        userLoginResponse: state.userLoginResponse,
        // rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class SummativeRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  SummativeRoutingData({
    this.rotation,
    required this.route
  });

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    SummativeRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => SummativeConnector(
        rotation: data.rotation!,
        route: data.route!,
      ),
    );
  }
}
