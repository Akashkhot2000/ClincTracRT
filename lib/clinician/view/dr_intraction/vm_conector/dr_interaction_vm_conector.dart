import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/dr_intraction/view/dr_intraction_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class DrInteractionListScreenConector extends StatelessWidget {
  /// Constructor for [DrInteractionListScreenConector]
  DrInteractionListScreenConector({
    Key? key,
    required this.showAdd,
    required this.rotation,
  }) : super(key: key);

  final bool showAdd;

  Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrInteractionListScreenVM>(
      model: DrInteractionListScreenVM(),
      builder: (BuildContext context, DrInteractionListScreenVM vm) =>
          DrInteractionListScreen(
        rotation: rotation,
        showAdd: showAdd,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        drInteractionList: vm.drInteractionList,
        active_status: vm.active_status,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class DrInteractionListScreenVM extends BaseModel<AppState> {
  /// Constructor for [DrInteractionListScreenVM]
  DrInteractionListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late StudentDrInteractionData drInteractionList;

  late RotationListStudentJournal rotationListStudentJournal;

  ///
  late Active_status active_status;

  DrInteractionListScreenVM.build(
      {required this.userLoginResponse,
      required this.drInteractionList,
      required this.rotationListStudentJournal,
      required this.active_status})
      : super(
          equals: <dynamic>[
            userLoginResponse,
            drInteractionList,
            rotationListStudentJournal,
            active_status
          ],
        );

  @override
  DrInteractionListScreenVM fromStore() => DrInteractionListScreenVM.build(
      userLoginResponse: state.userLoginResponse,
      rotationListStudentJournal: state.rotationListStudentJournal,
      drInteractionList: state.drInteractionList,
      active_status: state.active_status);
}

class DrInteractionListScreenDta {
  /// Constructor for [DrInteractionListScreenDta] which is passed as argument for [DrInteractionListScreenConector]
  DrInteractionListScreenDta({
    required this.showAdd,
    this.rotation,
  });

  final bool showAdd;
  Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [DrInteractionListScreenConector] using [DrInteractionListScreenDta]
  static MaterialPageRoute<dynamic> resolveRoute(
    DrInteractionListScreenDta data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DrInteractionListScreenConector(
        showAdd: data.showAdd,
        rotation: data.rotation ??
            Rotation(
                rotationId: '',
                rotationTitle: '',
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                hospitalTitle: '',
                hospitalSiteId: '',
                isHospitalSiteActive: false,
                courseId: '',
                courseTitle: '',
                isClockIn: 0,
                attendanceId: '',
                clockInDateTime: DateTime.now(),
                isExpired: false),
      ),
    );
  }
}
