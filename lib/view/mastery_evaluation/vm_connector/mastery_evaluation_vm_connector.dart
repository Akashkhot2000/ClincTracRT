import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/daily_weekly/view/daily_weekly_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/mastery_evaluation/view/mastery_evaluation_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class MasteryEvaluationConnector extends StatelessWidget {
  Rotation rotation;
  MasteryEvaluationConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MasteryEvaluationViewModel>(
      model: MasteryEvaluationViewModel(),
      builder: (BuildContext context, MasteryEvaluationViewModel vm) =>
          MasteryEvaluationScreen(
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        rotationListStudentJournal: vm.rotationListStudentJournal,
      ),
    );
  }
}

class MasteryEvaluationViewModel extends BaseModel<AppState> {
  /// Constructor for [MasteryEvaluationViewModel]
  MasteryEvaluationViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  MasteryEvaluationViewModel.build({
    required this.userLoginResponse,
    required this.rotationListStudentJournal,
  }) : super(
          equals: [
            <dynamic>[
              userLoginResponse,
            ]
          ],
        );

  @override
  MasteryEvaluationViewModel fromStore() => MasteryEvaluationViewModel.build(
        userLoginResponse: state.userLoginResponse,
        rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class MasteryEvaluationRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  MasteryEvaluationRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    MasteryEvaluationRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => MasteryEvaluationConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
