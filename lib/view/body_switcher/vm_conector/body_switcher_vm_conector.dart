import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/initializeAction.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/body_switcher/view/body_switcher.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class BodySwitcherConnector extends StatelessWidget {
  /// Constructor for [BodySwitcherConnector]
  BodySwitcherConnector({
    Key? key,
    this.initialPage = Bottom_navigation_control.home,
    this.body
  }) : super(key: key);

  /// to load a particular page at initial time
  Bottom_navigation_control? initialPage;
  Widget? body;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BodySwitcherVM>(
      model: BodySwitcherVM(),
      builder: (BuildContext context, BodySwitcherVM vm) => BodySwitcher(
        userLoginResponse: vm.userLoginResponse,
        initializeApp: vm.initializeApp,
        studentDetails: vm.studentDetails,
        initialPage: initialPage,
        body: body,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class BodySwitcherVM extends BaseModel<AppState> {
  /// Constructor for [BodySwitcherVM]
  BodySwitcherVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late VoidCallback initializeApp;
  late StudentDetailsResponse studentDetails;

  BodySwitcherVM.build(
      {required this.userLoginResponse,
      required this.initializeApp,
      required this.studentDetails})
      : super(
          equals: <dynamic>[userLoginResponse, studentDetails],
        );

  @override
  BodySwitcherVM fromStore() => BodySwitcherVM.build(
        userLoginResponse: state.userLoginResponse,
        studentDetails: state.studentDetailsResponse,
        initializeApp: () => store.dispatch(initializeAppAction()),
      );
}

/// DO for passing the data for [BodySwitcherConnector]
class BodySwitcherData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  BodySwitcherData({
    this.initialPage,
    this.body,
  });

  /// to load a particular page at initial time
  final Bottom_navigation_control? initialPage;
  final Widget? body;
  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    BodySwitcherData data,
    RouteSettings settings,

  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => BodySwitcherConnector(
        initialPage: data.initialPage,
        body: data.body,
      ),
    );
  }
}
