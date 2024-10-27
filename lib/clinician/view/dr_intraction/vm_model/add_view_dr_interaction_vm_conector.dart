import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/dr_intraction/view/add_dr_interaction_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddViewDrInteractionListScreenConector extends StatelessWidget {
  /// Constructor for [AddViewDrInteractionListScreenConector]
  AddViewDrInteractionListScreenConector({
    Key? key,
    required this.drIntractionAction,
    this.drIntraction,
    required this.isFromDashboard,
    required this.rotationTitle,
    required this.hospitalTitle,
    required this.rotationID,
    required this.interactionDecCount,
  }) : super(key: key);

  final DrIntractionAction drIntractionAction;

  UniDrInteractionList? drIntraction;

  final bool isFromDashboard;

  final String rotationTitle;
  final String hospitalTitle;

  final String rotationID;
  final String interactionDecCount;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddViewDrInteractionListScreenVM>(
      model: AddViewDrInteractionListScreenVM(),
      builder: (BuildContext context, AddViewDrInteractionListScreenVM vm) =>
          AddDrIntractionScreen(
        rotationID: rotationID,
        interactionDecCount: this.interactionDecCount,
        rotationTitle: rotationTitle,
        drIntractionAction: drIntractionAction,
        drIntraction: drIntraction,
        clinicianDataList: vm.clinicianDataList,
        hospitalUnitListResponseDart: vm.hospitalUnitListResponseDart,
        rotationListStudentJournal: vm.rotationListStudentJournal,
            rotationForEvalListModel: vm.rotationForEvalListModel,
        isFromDashboard: isFromDashboard, hospitalTitle: hospitalTitle,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class AddViewDrInteractionListScreenVM extends BaseModel<AppState> {
  /// Constructor for [AddViewDrInteractionListScreenVM]
  AddViewDrInteractionListScreenVM();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;

  ///rotationList
  late StudentDrInteractionData drInteractionList;

  ///CourseList
  late CourseListModel courseListModel;

  ///
  late Active_status active_status;

  ///
  late ClinicianDataList clinicianDataList;

  late HospitalUnitListResponseDart hospitalUnitListResponseDart;

  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  AddViewDrInteractionListScreenVM.build(
      {required this.userLoginResponse,
      required this.drInteractionList,
      required this.courseListModel,
      required this.active_status,
      required this.hospitalUnitListResponseDart,
      required this.rotationListStudentJournal,
      required this.rotationForEvalListModel,
      required this.clinicianDataList})
      : super(
          equals: <dynamic>[
            userLoginResponse,
            drInteractionList,
            rotationListStudentJournal,
            courseListModel,
            active_status,
            clinicianDataList,
            hospitalUnitListResponseDart,
            rotationForEvalListModel
          ],
        );

  @override
  AddViewDrInteractionListScreenVM fromStore() =>
      AddViewDrInteractionListScreenVM.build(
          rotationListStudentJournal: state.rotationListStudentJournal,
          rotationForEvalListModel: state.rotationForEvalListModel,
          clinicianDataList: state.clinicianDataList,
          userLoginResponse: state.userLoginResponse,
          courseListModel: state.courseListModel,
          drInteractionList: state.drInteractionList,
          hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,
          active_status: state.active_status);
}

class AddViewDrIntgeractionData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddViewDrIntgeractionData({
    required this.drIntractionAction,
    required this.drIntraction,
    required this.isFromDashboard,
    required this.rotationTitle,
    required this.hospitalTitle,
    required this.rotationID,
    required this.interactionDecCount,
    // required this.pullToRefresh,
  });

  final DrIntractionAction drIntractionAction;

  UniDrInteractionList? drIntraction;

  final bool isFromDashboard;

  final String rotationTitle;
  final String hospitalTitle;

  final String rotationID;
  final String interactionDecCount;
   // Function pullToRefresh;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    AddViewDrIntgeractionData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddViewDrInteractionListScreenConector(
        drIntractionAction: data.drIntractionAction,
        drIntraction: data.drIntraction,
        isFromDashboard: data.isFromDashboard,
        rotationTitle: data.rotationTitle,
        hospitalTitle: data.hospitalTitle,
        rotationID: data.rotationID,
        interactionDecCount: data.interactionDecCount,
      ),
    );
  }
}
