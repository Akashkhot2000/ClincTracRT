import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/midterm_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/p_evaluation/view/p_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class GetPEvalListConector extends StatelessWidget {
  /// Constructor for [GetPEvalListConector]
  const GetPEvalListConector({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  final Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetPEvalListRoutingVM>(
      model: GetPEvalListRoutingVM(),
      builder: (BuildContext context, GetPEvalListRoutingVM vm) =>
          PEvaluationListScreen(
            rotation: rotation,
            userLoginResponse: vm.userLoginResponse,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class GetPEvalListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [GetPEvalListRoutingVM]
  GetPEvalListRoutingVM();

  late MidtermEvalList midtermEvalList;
  late UserLoginResponse userLoginResponse;

  GetPEvalListRoutingVM.build({
    required this.midtermEvalList,
    required this.userLoginResponse,
  }) : super(
    equals: <dynamic>[
      midtermEvalList,
      userLoginResponse
    ],
  );

  @override
  GetPEvalListRoutingVM fromStore() => GetPEvalListRoutingVM.build(
    userLoginResponse: state.userLoginResponse,
    midtermEvalList: state.midtermEvalList,
  );
}

class GetPEvalListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetPEvalListRoutingData({
    required this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      GetPEvalListRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          GetPEvalListConector(rotation: data.rotation!),
    );
  }
}
