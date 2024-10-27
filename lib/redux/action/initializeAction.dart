import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/action/get_country_list_action.dart';
import 'package:clinicaltrac/redux/action/get_dailyjournal_rotation_list.dart';
import 'package:clinicaltrac/redux/action/get_hospital_unit_list.dart';
import 'package:clinicaltrac/redux/action/get_student_details.dart';
import 'package:clinicaltrac/redux/app_state.dart';

/// TO set the child Id
class initializeAppAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    store.dispatch(getStudentDetailsAction());
    store.dispatch(getCountryListAction());
    store.dispatch(getStudentJournalRotationlistAction());
    store.dispatch(getHospitalUnitlistAction());
    return state.copy();
  }
}
