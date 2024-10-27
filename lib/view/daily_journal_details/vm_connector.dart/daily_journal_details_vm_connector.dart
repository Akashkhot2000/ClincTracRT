import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/daily_journal/view/DailyJournalScreen.dart';
import 'package:clinicaltrac/view/daily_journal_details/view/DailyJournalDetailScreen.dart';
import 'package:clinicaltrac/view/home/view/home_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/view/profile.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class DailyJournalDetailsScreenConnector extends StatelessWidget {
  final String JournalId;
  final String rotationId;
  final String hospitalTitle;
  final String hospitalId;
  final String journalDecCount;
  final DailyJournalViewType viewType;
  const DailyJournalDetailsScreenConnector({required this.JournalId, required this.viewType,required this.journalDecCount, required this.rotationId,required this.hospitalTitle, required this.hospitalId});

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DailyJournalDetailsScreenViewModel>(
      model: DailyJournalDetailsScreenViewModel(),
      builder: (BuildContext context, DailyJournalDetailsScreenViewModel vm) => DailyJournalDetailsScreen(
        JournalId: this.JournalId,
        rotationId: this.rotationId,
        hospitalTitle: this.hospitalTitle,
        hospitalId: this.hospitalId,
        journalDecCount: this.journalDecCount,
        Viewtype: this.viewType,
        user: vm.userLoginResponse,
        rotationList: vm.rotationListStudentJournal,
        hospitalUnitList: vm.hospitalUnitListResponseDart,
          rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class DailyJournalDetailsScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [DailyJournalDetailsScreenViewModel]
  DailyJournalDetailsScreenViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late HospitalUnitListResponseDart hospitalUnitListResponseDart;
  late RotationForEvalListModel rotationForEvalListModel;

  DailyJournalDetailsScreenViewModel.build(
      {required this.userLoginResponse, required this.rotationListStudentJournal, required this.hospitalUnitListResponseDart,required this.rotationForEvalListModel})
      : super(
          equals: [
            <dynamic>[userLoginResponse, rotationListStudentJournal, hospitalUnitListResponseDart,rotationForEvalListModel]
          ],
        );

  @override
  DailyJournalDetailsScreenViewModel fromStore() => DailyJournalDetailsScreenViewModel.build(
      userLoginResponse: state.userLoginResponse,
      rotationListStudentJournal: state.rotationListStudentJournal,
      hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,
      rotationForEvalListModel: state.rotationForEvalListModel,
  );
}

class DailyJournalData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DailyJournalData({required this.JournalId, required this.viewType,required this.journalDecCount,required this.rotationId, required this.hospitalTitle, required this.hospitalId});

  /// to load a particular page at initial time
  final String? JournalId;
  final String? rotationId;
  final String? hospitalTitle;
  final String? hospitalId;
  final String? journalDecCount;
  final DailyJournalViewType? viewType;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    DailyJournalData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DailyJournalDetailsScreenConnector(
        JournalId: data.JournalId!,
        rotationId: data.rotationId!,
        hospitalTitle: data.hospitalTitle!,
        hospitalId: data.hospitalId!,
        journalDecCount: data.journalDecCount!,
        viewType: data.viewType!,
      ),
    );
  }
}
