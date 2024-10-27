import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/view/pef_evaluation_list_screen.dart';
import 'package:clinicaltrac/view/floor_therapy/view/floor_therapy_list_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

class GetFloorListConector extends StatelessWidget {
  /// Constructor for [GetFloorListConector]
  const GetFloorListConector({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  final Rotation rotation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetFloorListRoutingVM>(
      model: GetFloorListRoutingVM(),
      builder: (BuildContext context, GetFloorListRoutingVM vm) =>
          FloorTherapyListScreen(
            rotation: rotation,
            userLoginResponse: vm.userLoginResponse,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class GetFloorListRoutingVM extends BaseModel<AppState> {
  /// Constructor for [GetFloorListRoutingVM]
  GetFloorListRoutingVM();

  late UserLoginResponse userLoginResponse;

  GetFloorListRoutingVM.build({
    required this.userLoginResponse,
  }) : super(
    equals: <dynamic>[
      userLoginResponse
    ],
  );

  @override
  GetFloorListRoutingVM fromStore() => GetFloorListRoutingVM.build(
    userLoginResponse: state.userLoginResponse,
  );
}

class GetFloorListRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  GetFloorListRoutingData({
    required this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      GetFloorListRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) =>
          GetFloorListConector(rotation: data.rotation!),
    );
  }
}
