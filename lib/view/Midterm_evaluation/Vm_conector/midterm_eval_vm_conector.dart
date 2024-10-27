import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/midterm_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class getMidtermEvalListConector extends StatelessWidget {
  /// Constructor for [getMidtermEvalListConector]
  const getMidtermEvalListConector({
    Key? key,
    required this.rotation,
    required this.route,
  }) : super(key: key);

  final Rotation rotation;
  final DailyJournalRoute route;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, getMidtermEvalListRoutingVM>(
      model: getMidtermEvalListRoutingVM(),
      builder: (BuildContext context, getMidtermEvalListRoutingVM vm) =>
          MidtermEvaluationListScreen(
        rotation: rotation,
            userLoginResponse: vm.userLoginResponse,
            route: route,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class getMidtermEvalListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [getMidtermEvalListRoutingVM]
  getMidtermEvalListRoutingVM();

  late MidtermEvalList midtermEvalList;
  late UserLoginResponse userLoginResponse;

  getMidtermEvalListRoutingVM.build({
    required this.midtermEvalList,
    required this.userLoginResponse,
  }) : super(
          equals: <dynamic>[
            midtermEvalList,
            userLoginResponse
          ],
        );

  @override
  getMidtermEvalListRoutingVM fromStore() => getMidtermEvalListRoutingVM.build(
        userLoginResponse: state.userLoginResponse,
        midtermEvalList: state.midtermEvalList,
      );
}

class GetMidtermEvalListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetMidtermEvalListRoutingData({
    required this.rotation,
    required this.route,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    GetMidtermEvalListRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          getMidtermEvalListConector(
            rotation: data.rotation!,
            route: data.route!,
          ),
    );
  }
}
