import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/announcement/view/announcement_screen.dart';
import 'package:clinicaltrac/view/brief_case/view/brief_case_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AnnouncementConnector extends StatelessWidget {

  AnnouncementConnector({Key? key}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AnnouncementViewModel>(
      model: AnnouncementViewModel(),
      builder: (BuildContext context, AnnouncementViewModel vm) =>
          AnnouncementScreen(
            userLoginResponse: vm.userLoginResponse,

          ),
    );
  }
}

class AnnouncementViewModel extends BaseModel<AppState> {
  /// Constructor for [AnnouncementViewModel]
  AnnouncementViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  AnnouncementViewModel.build({
    required this.userLoginResponse,
    required this.rotationListStudentJournal,
  }) : super(
    equals: [
      <dynamic>[
        userLoginResponse,
      ]
    ],
  );

  @override
  AnnouncementViewModel fromStore() => AnnouncementViewModel.build(
    userLoginResponse: state.userLoginResponse,
    rotationListStudentJournal: state.rotationListStudentJournal,
  );
}

class AnnouncementRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AnnouncementRoutingData();

  /// to load a particular page at initial time


  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(

      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AnnouncementConnector(),
    );
  }
}
