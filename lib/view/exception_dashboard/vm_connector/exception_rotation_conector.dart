import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/exception_dashboard/view/exception_rotations_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/rotations_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class ExceptionRotationListConector extends StatelessWidget {
  /// Constructor for [RotationListScreenConector]
  const ExceptionRotationListConector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExceptionRotationListScreenVM>(
      model: ExceptionRotationListScreenVM(),
      builder: (BuildContext context, ExceptionRotationListScreenVM vm) =>
          ExceptionRotationsList(
            allRotationListModel: vm.allRotationListModel,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class ExceptionRotationListScreenVM extends BaseModel<AppState> {
  /// Constructor for [ExceptionRotationListScreenVM]
  ExceptionRotationListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late RotationListModel rotationListModel;

  late AllRotationListModel allRotationListModel;

  ExceptionRotationListScreenVM.build(
      {required this.userLoginResponse,
      required this.rotationListModel,
      required this.allRotationListModel,})
      : super(
          equals: <dynamic>[
            userLoginResponse,
            rotationListModel,
            allRotationListModel,
          ],
        );

  @override
  ExceptionRotationListScreenVM fromStore() =>
      ExceptionRotationListScreenVM.build(
          userLoginResponse: state.userLoginResponse,
          rotationListModel: state.rotationListModel,
        allRotationListModel: state.allRotationListModel,);
}
