// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/common/enums.dart';
// import 'package:clinicaltrac/model/course_list_model.dart';
// import 'package:clinicaltrac/model/hospital_unit_list.dart';
// import 'package:clinicaltrac/model/roatation_list.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
// import 'package:clinicaltrac/view/check_offs/model/course_topic_list_model.dart';
// import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
// import 'package:clinicaltrac/view/check_offs/view/add_checkoffs_screen.dart';
// import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
// import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
// import 'package:clinicaltrac/view/dr_intraction/view/add_dr_interaction_screen.dart';
// import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
// import 'package:flutter/material.dart';

// /// Connector for [HomePageScreen]
// class AddCheckoffsConnector extends StatelessWidget {
//   /// Constructor for [AddCheckoffsConnector]
//   AddCheckoffsConnector({
//     Key? key,
//     required this.rotationTitle,
//     required this.rotationID,
//   }) : super(key: key);
//
//   final String rotationTitle;
//
//   final String rotationID;
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, AddCheckoffsViewModel>(
//       model: AddCheckoffsViewModel(),
//       builder: (BuildContext context, AddCheckoffsViewModel vm) =>
//     AddCheckoffsScreen(
//         //pageChange: pageChange,
//         userLoginResponse: vm.userLoginResponse,
//         rotationID: rotationID,
//         rotationTitle: rotationTitle,
//         studentCheckoffsListModel: vm.studentCheckoffsListModel,
//         clinicianDataList: vm.clinicianDataList,
//         hospitalUnitListResponseDart: vm.hospitalUnitListResponseDart,
//         rotationListStudentJournal: vm.rotationListStudentJournal,
//         courseTopicListModel: vm.courseTopicListModel,
//         rotationForEvalListModel: vm.rotationForEvalListModel,
//       ),
//     );
//   }
// }
//
// /// View Model for [HomePageScreen]
// class AddCheckoffsViewModel extends BaseModel<AppState> {
//   /// Constructor for [AddCheckoffsViewModel]
//   AddCheckoffsViewModel();
//
//   ///userLoginResponse
//   late UserLoginResponse userLoginResponse;
//
//   late StudentCheckoffsListModel studentCheckoffsListModel;
//   late RotationForEvalListModel rotationForEvalListModel;
//   late CourseTopicListModel courseTopicListModel;
//
//   ///
//   late ClinicianDataList clinicianDataList;
//
//   late HospitalUnitListResponseDart hospitalUnitListResponseDart;
//
//   late RotationListStudentJournal rotationListStudentJournal;
//
//   AddCheckoffsViewModel.build(
//       {required this.userLoginResponse,
//         required this.studentCheckoffsListModel,
//         required this.rotationForEvalListModel,
//         required this.courseTopicListModel,
//         required this.hospitalUnitListResponseDart,
//         required this.rotationListStudentJournal,
//         required this.clinicianDataList})
//       : super(
//     equals: <dynamic>[
//       userLoginResponse,
//       studentCheckoffsListModel,
//       rotationListStudentJournal,
//       rotationForEvalListModel,
//       courseTopicListModel,
//       clinicianDataList,
//       hospitalUnitListResponseDart
//     ],
//   );
//
//   @override
//   AddCheckoffsViewModel fromStore() =>
//       AddCheckoffsViewModel.build(
//           rotationListStudentJournal: state.rotationListStudentJournal,
//           clinicianDataList: state.clinicianDataList,
//           userLoginResponse: state.userLoginResponse,
//           rotationForEvalListModel: state.rotationForEvalListModel,
//           studentCheckoffsListModel: state.studentCheckoffsListModel,
//           hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,
//           courseTopicListModel: state.courseTopicListModel);
// }
//
// class AddCheckoffRoutingData {
//   /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
//   AddCheckoffRoutingData({
//     required this.rotationTitle,
//     required this.rotationId,
//   });
//
//   final String rotationTitle;
//
//   final String rotationId;
//
//   /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
//   static MaterialPageRoute<dynamic> resolveRoute(
//       AddCheckoffRoutingData data,
//       RouteSettings settings,
//       ) {
//     return MaterialPageRoute<dynamic>(
//       settings: settings,
//       builder: (BuildContext context) => AddCheckoffsConnector(
//         rotationTitle: data.rotationTitle,
//         rotationID: data.rotationId,
//       ),
//     );
//   }
// }

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/course_topic_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/check_offs/view/add_checkoffs_screen.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddCheckoffsConnector extends StatelessWidget {
  Rotation rotation;

  AddCheckoffsConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddCheckoffsViewModel>(
      model: AddCheckoffsViewModel(),
      builder: (BuildContext context, AddCheckoffsViewModel vm) =>
          AddCheckoffsScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        studentCheckoffsListModel: vm.studentCheckoffsListModel,
        clinicianDataList: vm.clinicianDataList,
        hospitalUnitListResponseDart: vm.hospitalUnitListResponseDart,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        courseTopicListModel: vm.courseTopicListModel,
        allCourseTopicListModel: vm.allCourseTopicListModel,
        rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class AddCheckoffsViewModel extends BaseModel<AppState> {
  /// Constructor for [AddCheckoffsViewModel]
  AddCheckoffsViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late StudentCheckoffsListModel studentCheckoffsListModel;
  late RotationForEvalListModel rotationForEvalListModel;
  late CourseTopicListModel courseTopicListModel;
  late CourseTopicListModel allCourseTopicListModel;
  late ClinicianDataList clinicianDataList;
  late HospitalUnitListResponseDart hospitalUnitListResponseDart;
  late RotationListStudentJournal rotationListStudentJournal;

  AddCheckoffsViewModel.build({
    required this.userLoginResponse,
    required this.studentCheckoffsListModel,
    required this.rotationForEvalListModel,
    required this.courseTopicListModel,
    required this.allCourseTopicListModel,
    required this.clinicianDataList,
    required this.hospitalUnitListResponseDart,
    required this.rotationListStudentJournal,
  }) : super(
          equals: [
            <dynamic>[
              userLoginResponse,
              rotationForEvalListModel,
              courseTopicListModel,
              allCourseTopicListModel,
              clinicianDataList,
              hospitalUnitListResponseDart,
              rotationListStudentJournal,
            ]
          ],
        );

  @override
  AddCheckoffsViewModel fromStore() => AddCheckoffsViewModel.build(
        userLoginResponse: state.userLoginResponse,
        studentCheckoffsListModel: state.studentCheckoffsListModel,
        rotationForEvalListModel: state.rotationForEvalListModel,
        courseTopicListModel: state.courseTopicListModel,
        allCourseTopicListModel: state.allCourseTopicListModel,
        clinicianDataList: state.clinicianDataList,
        hospitalUnitListResponseDart: state.hospitalUnitListResponseDart,
        rotationListStudentJournal: state.rotationListStudentJournal,
      );
}

class AddCheckoffRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddCheckoffRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    AddCheckoffRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddCheckoffsConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
