import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/Midterm_evaluation/view/add_midterm_screen.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/daily_weekly/view/add_dailyweekly_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/summative/view/add_summative_screen.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddDailyWeeklyConnector extends StatelessWidget {
 final String rotation;
 final String rotationId;
 final DailyJournalViewType viewType;
  AddDailyWeeklyConnector({Key? key, required this.rotation, required this.viewType,required this.rotationId}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddDailyWeeklyViewModel>(
      model: AddDailyWeeklyViewModel(),
      builder: (BuildContext context, AddDailyWeeklyViewModel vm) => AddDailyWeeklyScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: this.rotation,
        rotationId: this.rotationId,
        Viewtype: this.viewType,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class AddDailyWeeklyViewModel extends BaseModel<AppState> {
  /// Constructor for [AddDailyWeeklyViewModel]
  AddDailyWeeklyViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  //late VoidCallback getAttendance;

  AddDailyWeeklyViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal,
    required this.rotationForEvalListModel,
  })
      : super(
    equals: [
      <dynamic>[
        userLoginResponse,
        rotationForEvalListModel
      ]
    ],
  );

  @override
  AddDailyWeeklyViewModel fromStore() => AddDailyWeeklyViewModel.build(
    userLoginResponse: state.userLoginResponse,
    rotationListStudentJournal: state.rotationListStudentJournal,
    rotationForEvalListModel:state.rotationForEvalListModel
  );
}

class AddDailyWeeklyRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddDailyWeeklyRoutingData({
  required  this.rotation,
  required  this.rotationId,
    required this.viewType

  });

  /// to load a particular page at initial time
  final String rotation;
  final String? rotationId;
  final DailyJournalViewType? viewType;
  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      AddDailyWeeklyRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddDailyWeeklyConnector(
        rotation: data.rotation,
        rotationId: data.rotationId!,
        viewType: data.viewType!,
      ),
    );
  }
}
