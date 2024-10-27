import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/daily_weekly/view/daily_weekly_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class DailyWeeklyConnector extends StatelessWidget {
  final Rotation? rotation;
  final DailyJournalRoute route;

  const DailyWeeklyConnector({Key? key, this.rotation, required this.route})
      : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DailyWeeklyViewModel>(
      model: DailyWeeklyViewModel(),
      builder: (BuildContext context, DailyWeeklyViewModel vm) =>
          dailyWeeklyScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        route: route,
      ),
    );
  }
}

class DailyWeeklyViewModel extends BaseModel<AppState> {
  /// Constructor for [DailyWeeklyViewModel]
  DailyWeeklyViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  //late VoidCallback getAttendance;

  DailyWeeklyViewModel.build({
    required this.userLoginResponse,
    required this.rotationListStudentJournal,
  }) : super(
          equals: [
            <dynamic>[
              userLoginResponse,
              rotationListStudentJournal
            ]
          ],
        );

  @override
  DailyWeeklyViewModel fromStore() => DailyWeeklyViewModel.build(
        userLoginResponse: state.userLoginResponse,
        rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class DailyWeeklyRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DailyWeeklyRoutingData({this.rotation, required this.route});

  /// to load a particular page at initial time
  final Rotation? rotation;
  final DailyJournalRoute? route;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    DailyWeeklyRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DailyWeeklyConnector(
        rotation: data.rotation,
        route: data.route!,
      ),
    );
  }
}
