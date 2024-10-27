import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/menu_add_remove_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class getMenuAddRemoveAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final DataService dataService = locator();
    MenuAddRemoveModel menuAddRemoveModel = MenuAddRemoveModel(
      data: MenuAddRemoveData(
        attendance: false,
        caseStudy: false,
        incident: false,
        briefcase: false,
        exception: false,
        medicalTerminology: false,
        chat: false,
        cIEvaluation: false,
        pEvaluation: false,
        dailyJournal: false,
        pEFEvaluation: false,
        dailyWeekly: false,
        drInteraction: false,
        equipmentList: false,
        floorTherapyAndICU: false,
        formative: false,
        help: false,
        volunterEvaluation: false,
        masteryEvaluation: false,
        midterm: false,
        siteEvaluation: false,
        summative: false,
      ),
    );
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataResponseModel dataResponseModel =
        await dataService.getMenuAddRemove( box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,);
    if (dataResponseModel.success) {
      menuAddRemoveModel =
          MenuAddRemoveModel.fromJson(dataResponseModel.data);
    }
    return state.copy(menuAddRemoveModel: menuAddRemoveModel);
  }

  @override
  void after() {

  }
}
