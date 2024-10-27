import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/medical_terminology_action.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/medical_treminology/model/medical_terminology_model.dart';
import 'package:clinicaltrac/view/medical_treminology/view/medical_terminology_screen.dart';
import 'package:flutter/material.dart';

class MedicalTerminologyScreenConector extends StatelessWidget {
  /// Constructor for [MedicalTerminologyScreenConector]
  const MedicalTerminologyScreenConector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MedicalTerminologyScreenVM>(
      model: MedicalTerminologyScreenVM(),
      builder: (BuildContext context, MedicalTerminologyScreenVM vm) =>
          MedicalTerminologyScreen(
        userLoginResponse: vm.userLoginResponse,
        medicalTerminologyModel: vm.medicalTerminologyModel,
      ),
    );
  }
}

/// View Model for [HomePageScreen]
class MedicalTerminologyScreenVM extends BaseModel<AppState> {
  /// Constructor for [MedicalTerminologyScreenVM]
  MedicalTerminologyScreenVM();

  late MedicalTerminologyModel medicalTerminologyModel;
  late UserLoginResponse userLoginResponse;
  late VoidCallback getMedicalTerminology;

  MedicalTerminologyScreenVM.build(
      {required this.medicalTerminologyModel,
      required this.userLoginResponse,
      required this.getMedicalTerminology})
      : super(
          equals: <dynamic>[
            medicalTerminologyModel,
          ],
        );

  @override
  MedicalTerminologyScreenVM fromStore() => MedicalTerminologyScreenVM.build(
      userLoginResponse: state.userLoginResponse,
      medicalTerminologyModel: state.medicalTerminologyModel,
      getMedicalTerminology: () => store.dispatch(getMedicalTermListAction()));
}
