// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/main.dart';
// import 'package:clinicaltrac/model/roatation_list.dart';
// import 'package:clinicaltrac/redux/action/procedurecount_action/procedure_count_action.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_screen.dart';
// import 'package:flutter/material.dart';
//
// class ProcedureCountScreenConector extends StatelessWidget {
//   /// Constructor for [ProcedureCountScreenConector]
//   const ProcedureCountScreenConector({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ProcedureCountScreenVM>(
//       model: ProcedureCountScreenVM(),
//       builder: (BuildContext context, ProcedureCountScreenVM vm) =>
//           ProcedureCountScreen(
//         procedureCountModel: vm.procedureCountModel,
//         userLoginResponse: vm.userLoginResponse,
//         rotationListStudentJournal: vm.rotationListStudentJournal,
//       ),
//     );
//   }
// }
//
// /// View Model for [HomePageScreen]
// class ProcedureCountScreenVM extends BaseModel<AppState> {
//   /// Constructor for [ProcedureCountScreenVM]
//   ProcedureCountScreenVM();
//
//   late UserLoginResponse userLoginResponse;
//   late RotationListStudentJournal rotationListStudentJournal;
//   late VoidCallback getProcedureCount;
//   late ProcedureCountModel procedureCountModel;
//
//   ProcedureCountScreenVM.build({
//     required this.userLoginResponse,
//     required this.rotationListStudentJournal,
//     required this.getProcedureCount,
//     required this.procedureCountModel,
//   }) : super(
//           equals: <dynamic>[
//             procedureCountModel,
//           ],
//         );
//
//   @override
//   ProcedureCountScreenVM fromStore() => ProcedureCountScreenVM.build(
//         userLoginResponse: state.userLoginResponse,
//         rotationListStudentJournal: state.rotationListStudentJournal,
//         getProcedureCount: () => store.dispatch(getProcedureCountAction()),
//         procedureCountModel: state.procedureCountModel,
//       );
// }
