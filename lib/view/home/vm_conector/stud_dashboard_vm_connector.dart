// import 'package:async_redux/async_redux.dart';
// import 'package:clinicaltrac/redux/app_state.dart';
// import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
// import 'package:clinicaltrac/view/home/model/stud_dashboard_model.dart';
// import 'package:clinicaltrac/view/home/view/home_screen.dart';
// import 'package:clinicaltrac/view/home/view/upcoming_coursal.dart';
// import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
// import 'package:flutter/material.dart';
//
// /// Connector for [HomePageScreen]
// class StudDashboardDataScreenConector extends StatelessWidget {
//   /// Constructor for [StudDashboardDataScreenConector]
//   const StudDashboardDataScreenConector({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, StudDashboardDataScreenVM>(
//       model: StudDashboardDataScreenVM(),
//       builder: (BuildContext context, StudDashboardDataScreenVM vm) =>
//           HomeScreen(
//             studDashboardModel: vm.studDashboardModel,
//           ),
//     );
//   }
// }
//
// /// View Model for [HomePageScreen]
// class StudDashboardDataScreenVM extends BaseModel<AppState> {
//   /// Constructor for [StudDashboardDataScreenVM]
//   StudDashboardDataScreenVM();
//
//   ///userLoginResponse
//   late UserLoginResponse userLoginResponse;
//
//   ///rotationList
//   late StudDashboardModel studDashboardModel;
//
//   StudDashboardDataScreenVM.build(
//       {required this.userLoginResponse,
//         required this.studDashboardModel,
//       })
//       : super(
//     equals: <dynamic>[
//       userLoginResponse,
//       studDashboardModel,
//     ],
//   );
//
//   @override
//   StudDashboardDataScreenVM fromStore() => StudDashboardDataScreenVM.build(
//     userLoginResponse: state.userLoginResponse,
//     studDashboardModel: state.studDashboardModel,);
// }
