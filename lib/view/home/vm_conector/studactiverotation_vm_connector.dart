import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:clinicaltrac/view/home/view/upcoming_coursal.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class StudActiveRotationListScreenConector extends StatelessWidget {
  /// Constructor for [StudActiveRotationListScreenConector]
  const StudActiveRotationListScreenConector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StudActiveRotationListScreenVM>(
      model: StudActiveRotationListScreenVM(),
      builder: (BuildContext context, StudActiveRotationListScreenVM vm) =>
          UpcominCoursalBox(
        active_status: vm.active_status,
        activeRotationListModel: vm.activeRotationListModel,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class StudActiveRotationListScreenVM extends BaseModel<AppState> {
  /// Constructor for [StudActiveRotationListScreenVM]
  StudActiveRotationListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late ActiveRotationListModel activeRotationListModel;

  late Active_status active_status;

  StudActiveRotationListScreenVM.build(
      {required this.userLoginResponse,
      required this.activeRotationListModel,
      required this.active_status})
      : super(
          equals: <dynamic>[
            userLoginResponse,
            activeRotationListModel,
            active_status
          ],
        );

  @override
  StudActiveRotationListScreenVM fromStore() =>
      StudActiveRotationListScreenVM.build(
        userLoginResponse: state.userLoginResponse,
        activeRotationListModel: state.activeRotationListModel,
        active_status: state.active_status,
      );
}
