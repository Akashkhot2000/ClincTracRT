import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/rotations/view/rotation_list_widget.dart';
import 'package:flutter/material.dart';

class RotationListConector extends StatelessWidget {
  /// Constructor for [RotationListScreenConector]
  const RotationListConector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RotationListScreenVM>(
      model: RotationListScreenVM(),
      builder: (BuildContext context, RotationListScreenVM vm) =>
          RotationsListScreenWidget(
            courseListModel: vm.courseListModel,
            rotationListModel: vm.rotationListModel,
            active_status: vm.active_status,
          ),
    );
  }
}

/// View Model for [HomePageScreen]
class RotationListScreenVM extends BaseModel<AppState> {
  /// Constructor for [RotationListScreenVM]
  RotationListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late RotationListModel rotationListModel;

  ///CourseList
  late CourseListModel courseListModel;

  ///
  late Active_status active_status;

  RotationListScreenVM.build(
      {required this.userLoginResponse,
      required this.rotationListModel,
      required this.courseListModel,
      required this.active_status})
      : super(
          equals: <dynamic>[
            userLoginResponse,
            rotationListModel,
            courseListModel,
            active_status
          ],
        );

  @override
  RotationListScreenVM fromStore() => RotationListScreenVM.build(
      userLoginResponse: state.userLoginResponse,
      courseListModel: state.courseListModel,
      rotationListModel: state.rotationListModel,
      active_status: state.active_status);
}
