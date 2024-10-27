import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/checkoffs_action/checkoffs_list_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/check_offs/view/checkoffs_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class CheckoffsScreenConector extends StatelessWidget {
  /// Constructor for [CheckoffsScreenConector]
   CheckoffsScreenConector({
    Key? key,
     required this.route,
    required this.rotation,
  }) : super(key: key);
  // final bool showAdd;

  Rotation rotation;
   final DailyJournalRoute route;
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoffsScreenVM>(
      model: CheckoffsScreenVM(),
      builder: (BuildContext context, CheckoffsScreenVM vm) =>
          CheckOffsListScreen(
            rotation: rotation,
            route: route,
            rotationForEvalListModel: vm.rotationForEvalListModel,
            userLoginResponse: vm.userLoginResponse,
            checkoffsListModel: vm.studentCheckoffsListModel,
            rotationListStudentJournal: vm.rotationListStudentJournal,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class CheckoffsScreenVM extends BaseModel<AppState> {
  /// Constructor for [CheckoffsScreenVM]
  CheckoffsScreenVM();

  late StudentCheckoffsListModel studentCheckoffsListModel;
  late UserLoginResponse userLoginResponse;
  late VoidCallback getCheckoffsList;
  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  CheckoffsScreenVM.build(
      {required this.studentCheckoffsListModel,
        required this.userLoginResponse,
        required this.getCheckoffsList,required this.rotationListStudentJournal,required this.rotationForEvalListModel})
      : super(
    equals: <dynamic>[
      studentCheckoffsListModel,
    ],
  );

  @override
  CheckoffsScreenVM fromStore() => CheckoffsScreenVM.build(
      userLoginResponse: state.userLoginResponse,
      studentCheckoffsListModel: state.studentCheckoffsListModel,
      rotationForEvalListModel: state.rotationForEvalListModel,
      getCheckoffsList: () => store.dispatch(getCheckoffsListAction()), rotationListStudentJournal: state.rotationListStudentJournal);
}


class CheckoffsDta {
  /// Constructor for [CheckoffsDta] which is passed as argument for [CheckoffsScreenConector]
  CheckoffsDta({
    required this.showAdd,
    this.rotation,
    required this.route,
  });

  final bool showAdd;
  Rotation? rotation;
  final DailyJournalRoute route;

  /// Static method to obtain the [MaterialPageRoute] for [CheckoffsScreenConector] using [CheckoffsDta]
  static MaterialPageRoute<dynamic> resolveRoute(
      CheckoffsDta data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => CheckoffsScreenConector(
        route: data.route,
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
                clockInDateTime:  DateTime.now(),
                isExpired: false,
            isSchedule: ''),
      ),
    );
  }
}