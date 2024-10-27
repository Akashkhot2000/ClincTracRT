import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/summative/view/add_summative_screen.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddSummativeConnector extends StatelessWidget {
  Rotation rotation;
  AddSummativeConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddSummativeViewModel>(
      model: AddSummativeViewModel(),
      builder: (BuildContext context, AddSummativeViewModel vm) => AddSummativeScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class AddSummativeViewModel extends BaseModel<AppState> {
  /// Constructor for [AddSummativeViewModel]
  AddSummativeViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  //late VoidCallback getAttendance;

  AddSummativeViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal,
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
  AddSummativeViewModel fromStore() => AddSummativeViewModel.build(
    userLoginResponse: state.userLoginResponse,
    rotationListStudentJournal: state.rotationListStudentJournal,
    rotationForEvalListModel: state.rotationForEvalListModel,
  );
}

class AddSummativeRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddSummativeRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      AddSummativeRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddSummativeConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
