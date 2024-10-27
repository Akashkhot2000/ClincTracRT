import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/model/ActiveRotationStatus.dart';
import 'package:clinicaltrac/redux/app_state.dart';

class ActiveRotationStatusAction extends ReduxAction<AppState> {
  ActiveRotationStatusAction({
    required this.activeRotationStatus,
  });

  final ActiveRotationStatus activeRotationStatus;

  @override
  Future<AppState> reduce() async {
    return state.copy(activeRotationStatus: activeRotationStatus);
  }
}
