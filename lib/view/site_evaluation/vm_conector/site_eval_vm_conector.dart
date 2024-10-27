import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/ci/view/ci_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/site_evaluation/site_evlauation_list_screen.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class SiteEvaluationConnector extends StatelessWidget {
  Rotation rotation;
  SiteEvaluationConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SiteEvaluationVM>(
        model: SiteEvaluationVM(),
        builder: (BuildContext context, SiteEvaluationVM vm) => SiteEvaluationListScreen(
            userLoginResponse: vm.userLoginResponse, rotation: rotation)
        // CIScreen(
        //     //pageChange: pageChange,
        //     userLoginResponse: vm.userLoginResponse,
        //     rotation: rotation
        //     // rotationListStudentJournal: vm.rotationListStudentJournal,
        //     ),
        );
  }
}

class SiteEvaluationVM extends BaseModel<AppState> {
  /// Constructor for [SiteEvaluationVM]
  SiteEvaluationVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  //late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  SiteEvaluationVM.build({
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
  SiteEvaluationVM fromStore() => SiteEvaluationVM.build(
        userLoginResponse: state.userLoginResponse,
        // rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class SiteEvaluationRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  SiteEvaluationRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    SiteEvaluationRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => SiteEvaluationConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
