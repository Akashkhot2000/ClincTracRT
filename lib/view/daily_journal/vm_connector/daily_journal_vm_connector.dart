import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/daily_journal/view/DailyJournalScreen.dart';
import 'package:clinicaltrac/view/home/view/home_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/view/profile.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';

import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class DailyJournalScreenConnector extends StatelessWidget {
  final Rotation? rotation;
  final DailyJournalRoute route;
  const DailyJournalScreenConnector({Key? key, this.rotation, required this.route}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DailyJournalScreenViewModel>(
      model: DailyJournalScreenViewModel(),
      builder: (BuildContext context, DailyJournalScreenViewModel vm) => DailyJournalScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotation: rotation,
        route: route,
      ),
    );
  }
}

class DailyJournalScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [DailyJournalScreenViewModel]
  DailyJournalScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  DailyJournalScreenViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal})
      : super(
          equals: [
            <dynamic>[userLoginResponse, rotationListStudentJournal]
          ],
        );

  @override
  DailyJournalScreenViewModel fromStore() =>
      DailyJournalScreenViewModel.build(userLoginResponse: state.userLoginResponse, rotationListStudentJournal: state.rotationListStudentJournal);
}

class DailyRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DailyRoutingData({this.rotation, required this.route});

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute? route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    DailyRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DailyJournalScreenConnector(
        rotation: data.rotation,
        route: data.route!,
      ),
    );
  }
}
