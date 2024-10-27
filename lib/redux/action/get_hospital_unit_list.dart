import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../api/data_locator.dart';
import '../../api/data_service.dart';
import '../../common/hardcoded.dart';
import '../app_state.dart';

class getHospitalUnitlistAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    final DataResponseModel dataResponseModel =
        await dataService.getHospitalSiteUnit( box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,);
    HospitalUnitListResponseDart hospitalUnitListResponse = HospitalUnitListResponseDart.fromJson(dataResponseModel.data);

    return state.copy(hospitalUnitListResponseDart: hospitalUnitListResponse);
  }
}
