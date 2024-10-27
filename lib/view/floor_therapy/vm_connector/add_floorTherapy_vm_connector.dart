import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/floor_therapy/view/add_floor_therapy_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class AddFloorTherapyConnector extends StatelessWidget {
  Rotation rotation;
  AddFloorTherapyConnector({Key? key, required this.rotation}) : super(key: key);

  /// page change callback
  //final ChangeScreen pageChange;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddFloorTherapyViewModel>(
      model: AddFloorTherapyViewModel(),
      builder: (BuildContext context, AddFloorTherapyViewModel vm) => AddFloorTherapyScreen(
        //pageChange: pageChange,
        userLoginResponse: vm.userLoginResponse,
        rotation: rotation,
        rotationListStudentJournal: vm.rotationListStudentJournal,
        rotationForEvalListModel: vm.rotationForEvalListModel,
      ),
    );
  }
}

class AddFloorTherapyViewModel extends BaseModel<AppState> {
  /// Constructor for [AddFloorTherapyViewModel]
  AddFloorTherapyViewModel();

  ///userLoginResponse
  late UserLoginResponse userLoginResponse;
  late RotationListStudentJournal rotationListStudentJournal;
  late RotationForEvalListModel rotationForEvalListModel;

  //late VoidCallback getAttendance;

  AddFloorTherapyViewModel.build({required this.userLoginResponse, required this.rotationListStudentJournal,
    required this.rotationForEvalListModel,
  })
      : super(
    equals: [
      <dynamic>[
        userLoginResponse,
        rotationForEvalListModel
      ]
    ],
  );

  @override
  AddFloorTherapyViewModel fromStore() => AddFloorTherapyViewModel.build(
      userLoginResponse: state.userLoginResponse,
      rotationListStudentJournal: state.rotationListStudentJournal,
      rotationForEvalListModel:state.rotationForEvalListModel
  );
}

class AddFloorTherapyRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  AddFloorTherapyRoutingData({
    this.rotation,
  });

  /// to load a particular page at initial time
  final Rotation? rotation;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
      AddFloorTherapyRoutingData data,
      RouteSettings settings,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => AddFloorTherapyConnector(
        rotation: data.rotation!,
      ),
    );
  }
}
