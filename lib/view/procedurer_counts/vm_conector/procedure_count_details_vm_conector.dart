// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_model.dart';
// import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_detail_screen.dart';
// import 'package:clinicaltrac/view/procedurer_counts/view/rotations_screen.dart';
// import 'package:flutter/material.dart';
//
// class ProcedureCountDetailConector extends StatelessWidget {
//   const ProcedureCountDetailConector({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ProcedureCountDetailScreenVM>(
//       model: ProcedureCountDetailScreenVM(),
//       builder: (BuildContext context, ProcedureCountDetailScreenVM vm) =>
//           ProcedureCountDetailScreen(
//         allRotation: vm.allRotationListModel,
//         procedureCountDetail: vm.procedureCountDetailsModel,
//       ),
//     );
//   }
// }
//
// class ProcedureCountDetailScreenVM extends BaseModel<AppState> {
//   ProcedureCountDetailScreenVM();
//
//   ///userLoginResponse
//   late UserLoginResponse userLoginResponse;
//
//   ///rotationList
//   late AllRotationListModel allRotationListModel;
//
//   late ProcedureCountDetailsModel procedureCountDetailsModel;
//
//   ProcedureCountDetailScreenVM.build({
//     required this.userLoginResponse,
//     required this.allRotationListModel,
//     required this.procedureCountDetailsModel,
//   }) : super(
//           equals: <dynamic>[
//             userLoginResponse,
//             allRotationListModel,
//             procedureCountDetailsModel
//           ],
//         );
//
//   @override
//   ProcedureCountDetailScreenVM fromStore() =>
//       ProcedureCountDetailScreenVM.build(
//         userLoginResponse: state.userLoginResponse,
//         allRotationListModel: state.allRotationListModel,
//         procedureCountDetailsModel: state.procedureCountDetailsModel,
//       );
// }
