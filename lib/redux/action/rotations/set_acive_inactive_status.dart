import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/redux/app_state.dart';

/// TO set the child Id
class SetActiveInactiveStatusAction extends ReduxAction<AppState> {
  SetActiveInactiveStatusAction({
    required this.active_status,
  });

  final Active_status active_status;

  @override
  Future<AppState> reduce() async {
    return state.copy(active_status: active_status);
  }
}
