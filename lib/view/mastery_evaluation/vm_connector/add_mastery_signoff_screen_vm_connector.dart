// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/model/roatation_list.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
// import 'package:clinicaltrac/view/mastery_evaluation/view/cpap_evaluation_list_screen.dart';
// import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
// import 'package:flutter/material.dart';
//
// /// Connector for [HomePageScreen]
// class AdMasterySignoffScreenConnector extends StatelessWidget {
//
//   AdMasterySignoffScreenConnector({Key? key}) : super(key: key);
//
//   /// page change callback
//   //final ChangeScreen pageChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, MasteryEvaluationCPAPEvaluationListScreenViewModel>(
//       model: MasteryEvaluationCPAPEvaluationListScreenViewModel(),
//       builder: (BuildContext context, MasteryEvaluationCPAPEvaluationListScreenViewModel vm) =>
//           CPAPEvaluationListScreen(),
//     );
//   }
// }
//
// class MasteryEvaluationCPAPEvaluationListScreenViewModel extends BaseModel<AppState> {
//   /// Constructor for [MasteryEvaluationCPAPEvaluationListScreenViewModel]
//   MasteryEvaluationCPAPEvaluationListScreenViewModel();
//
//   ///userLoginResponse
//   late UserLoginResponse userLoginResponse;
//   late RotationListStudentJournal rotationListStudentJournal;
//
//   //late VoidCallback getAttendance;
//
//   MasteryEvaluationCPAPEvaluationListScreenViewModel.build({
//     required this.userLoginResponse,
//     required this.rotationListStudentJournal,
//   }) : super(
//           equals: [
//             <dynamic>[
//               userLoginResponse,
//             ]
//           ],
//         );
//
//   @override
//   MasteryEvaluationCPAPEvaluationListScreenViewModel fromStore() => MasteryEvaluationCPAPEvaluationListScreenViewModel.build(
//         userLoginResponse: state.userLoginResponse,
//         rotationListStudentJournal: state.rotationListStudentJournal,
//       );
// }
//
// class MasteryEvaluationCPAPEvaluationListScreenRoutingData {
//   /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
//   MasteryEvaluationCPAPEvaluationListScreenRoutingData();
//
//   /// to load a particular page at initial time
//
//
//   /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
//   static MaterialPageRoute<dynamic> resolveRoute(
//     MasteryEvaluationCPAPEvaluationListScreenRoutingData data,
//     RouteSettings settings,
//   ) {
//     return MaterialPageRoute<dynamic>(
//       settings: settings,
//       builder: (BuildContext context) => AdMasterySignoffScreenConnector(),
//     );
//   }
// }
