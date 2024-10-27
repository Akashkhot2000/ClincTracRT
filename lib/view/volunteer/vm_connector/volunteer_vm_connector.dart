import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/view/pef_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/midterm_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class GetVolunteerListConnector extends StatelessWidget {
  /// Constructor for [GetVolunteerListConnector]
  const GetVolunteerListConnector({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  final Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetVolunteerListRoutingVM>(
      model: GetVolunteerListRoutingVM(),
      builder: (BuildContext context, GetVolunteerListRoutingVM vm) =>
          PEFListScreen(
        rotation: rotation,
        userLoginResponse: vm.userLoginResponse,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class GetVolunteerListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [GetVolunteerListRoutingVM]
  GetVolunteerListRoutingVM();

  late UserLoginResponse userLoginResponse;

  GetVolunteerListRoutingVM.build({
    required this.userLoginResponse,
  }) : super(
          equals: <dynamic>[userLoginResponse],
        );

  @override
  GetVolunteerListRoutingVM fromStore() => GetVolunteerListRoutingVM.build(
        userLoginResponse: state.userLoginResponse,
      );
}

class GetVolunteerListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetVolunteerListRoutingData({
    required this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    GetVolunteerListRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          GetVolunteerListConnector(rotation: data.rotation!),
    );
  }
}
