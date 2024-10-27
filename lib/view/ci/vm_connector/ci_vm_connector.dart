import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/ci/view/ci_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';

import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class CIConnector extends StatelessWidget {
  Rotation rotation;
  CIConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CIViewModel>(
        model: CIViewModel(), builder: (BuildContext context, CIViewModel vm) => CIScreen(userLoginResponse: vm.userLoginResponse, rotation: rotation)
       );
  }
}

class CIViewModel extends BaseModel<AppState> {
  /// Constructor for [CIViewModel]
  CIViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  //late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  CIViewModel.build({
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
  CIViewModel fromStore() => CIViewModel.build(
        userLoginResponse: state.userLoginResponse,
        // rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class CIRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  CIRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    CIRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => CIConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
