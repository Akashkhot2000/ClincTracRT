import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';

/// TO set the child Id
class removeProfileEditable extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    bool isProfileEditable = false;

    return state.copy(isProfileEditable: isProfileEditable);
  }
}

class makeProfileEditable extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    bool isProfileEditable = true;
    return state.copy(isProfileEditable: isProfileEditable);
  }
}
