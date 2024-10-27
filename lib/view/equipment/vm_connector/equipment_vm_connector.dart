import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/equipment/view/equipment_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/midterm_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/p_evaluation/view/p_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class GetEquipmentListConector extends StatelessWidget {
  /// Constructor for [GetEquipmentListConector]
  const GetEquipmentListConector({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  final Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetEquipmentListRoutingVM>(
      model: GetEquipmentListRoutingVM(),
      builder: (BuildContext context, GetEquipmentListRoutingVM vm) =>
          EquipmentListScreen(
            rotation: rotation,
            userLoginResponse: vm.userLoginResponse,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class GetEquipmentListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [GetEquipmentListRoutingVM]
  GetEquipmentListRoutingVM();

  late MidtermEvalList midtermEvalList;
  late UserLoginResponse userLoginResponse;

  GetEquipmentListRoutingVM.build({
    required this.midtermEvalList,
    required this.userLoginResponse,
  }) : super(
    equals: <dynamic>[
      midtermEvalList,
      userLoginResponse
    ],
  );

  @override
  GetEquipmentListRoutingVM fromStore() => GetEquipmentListRoutingVM.build(
    userLoginResponse: state.userLoginResponse,
    midtermEvalList: state.midtermEvalList,
  );
}

class GetEquipmentListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetEquipmentListRoutingData({
    required this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      GetEquipmentListRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          GetEquipmentListConector(rotation: data.rotation!),
    );
  }
}
