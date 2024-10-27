import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_details_response.dart';
import 'package:clinicaltrac/view/daily_journal_details/view/daily_journal_details_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

class DailyJournalDetailConnector extends StatelessWidget {
  final String JournalId;
  // final DailyJournalViewType viewType;
  const DailyJournalDetailConnector({required this.JournalId,
    // required this.viewType
  });

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DailyJournalDetailsViewModel>(
      model: DailyJournalDetailsViewModel(),
      builder: (BuildContext context, DailyJournalDetailsViewModel vm) => DailyJournalDetailScreen(
        JournalId: this.JournalId,
        // Viewtype: this.viewType,
        user: vm.userLoginResponse,
        detailsData: vm.dailyJournalDetailsResponse,
      ),
    );
  }
}

class DailyJournalDetailsViewModel extends BaseModel<AppState> {
  /// Constructor for [DailyJournalDetailsViewModel]
  DailyJournalDetailsViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late HospitalUnitListResponseDart hospitalUnitListResponseDart;
  late DailyJournalDetailsResponse dailyJournalDetailsResponse;

  DailyJournalDetailsViewModel.build(
      {required this.userLoginResponse, required this.rotationListStudentJournal, required this.hospitalUnitListResponseDart, required this.dailyJournalDetailsResponse})
      : super(
    equals: [
      <dynamic>[userLoginResponse, rotationListStudentJournal, hospitalUnitListResponseDart,dailyJournalDetailsResponse]
    ],
  );

  @override
  DailyJournalDetailsViewModel fromStore() => DailyJournalDetailsViewModel.build(
      userLoginResponse: state.userLoginResponse,
      rotationListStudentJournal: state.rotationListStudentJournal,
      hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,dailyJournalDetailsResponse: state.dailyJournalDetailsResponse);
}

class DailyJournalDetailData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DailyJournalDetailData({required this.JournalId,
    // required this.viewType
  });

  /// to load a particular page at initial time
  final String? JournalId;
  // final DailyJournalViewType? viewType;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      DailyJournalDetailData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DailyJournalDetailConnector(
        JournalId: data.JournalId!,
        // viewType: data.viewType!,
      ),
    );
  }
}
