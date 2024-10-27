import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/brief_case/view/brief_case_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class BriefCaseConnector extends StatelessWidget {

  BriefCaseConnector({Key? key}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BriefCaseViewModel>(
      model: BriefCaseViewModel(),
      builder: (BuildContext context, BriefCaseViewModel vm) =>
          BriefCaseScreen(
        userLoginResponse: vm.userLoginResponse,

      ),
    );
  }
}

class BriefCaseViewModel extends BaseModel<AppState> {
  /// Constructor for [BriefCaseViewModel]
  BriefCaseViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  BriefCaseViewModel.build({
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
  BriefCaseViewModel fromStore() => BriefCaseViewModel.build(
        userLoginResponse: state.userLoginResponse,
        rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class BriefCaseRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  BriefCaseRoutingData();

  /// to load a particular page at initial time


  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(

    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => BriefCaseConnector(),
    );
  }
}
