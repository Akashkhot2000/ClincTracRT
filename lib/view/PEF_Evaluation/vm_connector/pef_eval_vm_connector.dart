import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/view/pef_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/midterm_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class GetPefEvalListConector extends StatelessWidget {
  /// Constructor for [GetPefEvalListConector]
  const GetPefEvalListConector({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  final Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetPefEvalListRoutingVM>(
      model: GetPefEvalListRoutingVM(),
      builder: (BuildContext context, GetPefEvalListRoutingVM vm) =>
          PEFListScreen(
            rotation: rotation,
            userLoginResponse: vm.userLoginResponse,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class GetPefEvalListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [GetPefEvalListRoutingVM]
  GetPefEvalListRoutingVM();

  late UserLoginResponse userLoginResponse;

  GetPefEvalListRoutingVM.build({
    required this.userLoginResponse,
  }) : super(
    equals: <dynamic>[
      userLoginResponse
    ],
  );

  @override
  GetPefEvalListRoutingVM fromStore() => GetPefEvalListRoutingVM.build(
    userLoginResponse: state.userLoginResponse,
  );
}

class GetPefEvalListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetPefEvalListRoutingData({
    required this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      GetPefEvalListRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          GetPefEvalListConector(rotation: data.rotation!),
    );
  }
}
