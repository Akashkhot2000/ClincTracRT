import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/menu_add_remove_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:clinicaltrac/view/home/model/stud_dashboard_model.dart';
import 'package:clinicaltrac/view/home/view/home_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class HomePageScreenConnector extends StatelessWidget {
  /// Constructor for [HomePageScreenConnector]
  const HomePageScreenConnector({
    Key? key,
    required this.pageChange,
  }) : super(key: key);

  /// page change callback
  final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageScreenViewModel>(
      model: HomePageScreenViewModel(),
      builder: (BuildContext context, HomePageScreenViewModel vm) => HomeScreen(
        pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        activeRotationListModel: vm.activeRotationListModel,
        studDashboardModel: vm.studDashboardModel,
        studentDetailsResponse: vm.studentDetailsResponse,
        menuAddRemoveModelData: vm.menuAddRemoveModel,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class HomePageScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [HomePageScreenViewModel]
  HomePageScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late ActiveRotationListModel activeRotationListModel;
  late StudDashboardModel studDashboardModel;
  late StudentDetailsResponse studentDetailsResponse;
  late MenuAddRemoveModel menuAddRemoveModel;

  HomePageScreenViewModel.build(
      {required this.userLoginResponse, required this.activeRotationListModel, required this.studDashboardModel, required this.studentDetailsResponse,required this.menuAddRemoveModel})
      : super(
    equals: <dynamic>[userLoginResponse, studDashboardModel,menuAddRemoveModel],
  );

  @override
  HomePageScreenViewModel fromStore() => HomePageScreenViewModel.build(
    userLoginResponse: state.userLoginResponse,
    activeRotationListModel: state.activeRotationListModel,
    studDashboardModel: state.studDashboardModel,
    studentDetailsResponse: state.studentDetailsResponse,
    menuAddRemoveModel: state.menuAddRemoveModel,
  );
}
