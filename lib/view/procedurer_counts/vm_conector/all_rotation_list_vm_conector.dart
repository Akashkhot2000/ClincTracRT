import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/rotations_screen.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AllRotationListConector extends StatelessWidget {
  /// Constructor for [RotationListScreenConector]
  const AllRotationListConector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AllRotationListScreenVM>(
      model: AllRotationListScreenVM(),
      builder: (BuildContext context, AllRotationListScreenVM vm) =>
          ProcedureRotationsList(
        allRotationListModel: vm.allRotationListModel,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class AllRotationListScreenVM extends BaseModel<AppState> {
  /// Constructor for [AllRotationListScreenVM]
  AllRotationListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late AllRotationListModel allRotationListModel;

  AllRotationListScreenVM.build({
    required this.userLoginResponse,
    required this.allRotationListModel,
  }) : super(
          equals: <dynamic>[
            userLoginResponse,
            allRotationListModel,
          ],
        );

  @override
  AllRotationListScreenVM fromStore() => AllRotationListScreenVM.build(
        userLoginResponse: state.userLoginResponse,
        allRotationListModel: state.allRotationListModel,
      );
}
