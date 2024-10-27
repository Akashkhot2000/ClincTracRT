import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/dr_intraction/view/add_dr_interaction_screen.dart';
import 'package:clinicaltrac/view/dr_intraction/view/dr_interaction_detail_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class DrInteractionDetailScreenConector extends StatelessWidget {
  /// Constructor for [DrInteractionDetailScreenConector]
  DrInteractionDetailScreenConector({
    Key? key,
    required this.drIntractionAction,
    this.drIntraction,
    required this.isFromDashboard,
    required this.rotationTitle,
    required this.rotationID,
  }) : super(key: key);

  final DrIntractionAction drIntractionAction;

  UniDrInteractionList? drIntraction;

  final bool isFromDashboard;

  final String rotationTitle;

  final String rotationID;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddViewDrInteractionListScreenVM>(
      model: AddViewDrInteractionListScreenVM(),
      builder: (BuildContext context, AddViewDrInteractionListScreenVM vm) =>
          DrInteractionDetailScreen(
            rotationID: rotationID,
            rotationTitle: rotationTitle,
            drIntractionAction: drIntractionAction,
            drIntraction: drIntraction,
            clinicianDataList: vm.clinicianDataList,
            hospitalUnitListResponseDart: vm.hospitalUnitListResponseDart,
            rotationListStudentJournal: vm.rotationListStudentJournal,
            isFromDashboard: isFromDashboard,
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

  AddViewDrInteractionListScreenVM.build(
      {required this.userLoginResponse,
        required this.drInteractionList,
        required this.courseListModel,
        required this.active_status,
        required this.hospitalUnitListResponseDart,
        required this.rotationListStudentJournal,
        required this.clinicianDataList})
      : super(
    equals: <dynamic>[
      userLoginResponse,
      drInteractionList,
      rotationListStudentJournal,
      courseListModel,
      active_status,
      clinicianDataList,
      hospitalUnitListResponseDart
    ],
  );

  @override
  AddViewDrInteractionListScreenVM fromStore() =>
      AddViewDrInteractionListScreenVM.build(
          rotationListStudentJournal: state.rotationListStudentJournal,
          clinicianDataList: state.clinicianDataList,
          userLoginResponse: state.userLoginResponse,
          courseListModel: state.courseListModel,
          drInteractionList: state.drInteractionList,
          hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,
          active_status: state.active_status);
}

class DrInteractionDetailData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  DrInteractionDetailData({
    required this.drIntractionAction,
    required this.drIntraction,
    required this.isFromDashboard,
    required this.rotationTitle,
    required this.rotationId,
  });

  final DrIntractionAction drIntractionAction;

  UniDrInteractionList? drIntraction;

  final bool isFromDashboard;

  final String rotationTitle;

  final String rotationId;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      DrInteractionDetailData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => DrInteractionDetailScreenConector(
        drIntractionAction: data.drIntractionAction,
        drIntraction: data.drIntraction,
        isFromDashboard: data.isFromDashboard,
        rotationTitle: data.rotationTitle,
        rotationID: data.rotationId,
      ),
    );
  }
}
