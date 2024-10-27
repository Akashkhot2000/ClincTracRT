import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/redux/app_state.dart';

/// Redux action to reset the store values
class ResetStoreAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() {
    return AppState.initialState();
  }
}
