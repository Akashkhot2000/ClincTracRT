import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/attendance/get_attendance_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/view/attendanceScreen.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/formative/view/add_formative_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddFormativeConnector extends StatelessWidget {
  Rotation rotation;
  AddFormativeConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddFormativeViewModel>(
      model: AddFormativeViewModel(),
      builder: (BuildContext context, AddFormativeViewModel vm) => AddFormativeScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class AddFormativeViewModel extends BaseModel<AppState> {
  /// Constructor for [AddFormativeViewModel]
  AddFormativeViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  //late VoidCallback getAttendance;

  AddFormativeViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal,
      required this.rotationForEvalListModel,
      })
      : super(
          equals: [
            <dynamic>[
              userLoginResponse,
              rotationForEvalListModel,
            ]
          ],
        );

  @override
  AddFormativeViewModel fromStore() => AddFormativeViewModel.build(
        userLoginResponse: state.userLoginResponse,
        rotationListStudentJournal: state.rotationListStudentJournal,
    rotationForEvalListModel: state.rotationForEvalListModel,
      );
}

class AddFormativeRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddFormativeRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    AddFormativeRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddFormativeConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
