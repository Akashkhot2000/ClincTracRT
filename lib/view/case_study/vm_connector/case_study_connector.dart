import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/case_study/view/case_study_list_screen.dart';
import 'package:clinicaltrac/view/daily_journal/view/DailyJournalScreen.dart';
import 'package:clinicaltrac/view/home/view/home_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/view/profile.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';

import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class CaseStudyScreenConnector extends StatelessWidget {
  final Rotation? rotation;
  const CaseStudyScreenConnector({Key? key, this.rotation,}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CaseStudyScreenViewModel>(
      model: CaseStudyScreenViewModel(),
      builder: (BuildContext context, CaseStudyScreenViewModel vm) => CaseStudyListScreen(
        rotation: rotation,
      ),
    );
  }
}

class CaseStudyScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [CaseStudyScreenViewModel]
  CaseStudyScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;

  CaseStudyScreenViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal})
      : super(
    equals: [
      <dynamic>[userLoginResponse, rotationListStudentJournal]
    ],
  );

  @override
  CaseStudyScreenViewModel fromStore() =>
      CaseStudyScreenViewModel.build(userLoginResponse: state.userLoginResponse, rotationListStudentJournal: state.rotationListStudentJournal);
}

class CaseStudyRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  CaseStudyRoutingData({this.rotation,});

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      CaseStudyRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => CaseStudyScreenConnector(
        rotation: data.rotation,
      ),
    );
  }
}
