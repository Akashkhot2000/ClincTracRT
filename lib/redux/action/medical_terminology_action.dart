import 'dart:developer';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/medical_treminology/model/medical_terminology_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../common/hardcoded.dart';

/// TO get the child Id
class getMedicalTermListAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    final DataResponseModel dataResponseModel =
    await dataService.getCountryList( box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken,);
    MedicalTerminologyModel medicalTerminologyModel = MedicalTerminologyModel.fromJson(dataResponseModel.data);
    return state.copy(medicalTerminologyModel: medicalTerminologyModel);
  }

  // getMedicalTermListAction({
  //   required this.searchText,
  //   required this.pageNumber,
  // });
  //
  // final String searchText;
  // final String pageNumber;
  //
  // @override
  // Future<AppState> reduce() async {
  //   ///List for the course values
  //   MedicalTerminologyModel medicalTerminologyModel = MedicalTerminologyModel(
  //       data: [],
  //       pager: Pager());
  //   final DataService dataService = locator();
  //   final DataResponseModel dataResponseModel = await dataService.getMedicalTerminologyList(
  //        box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
  //         box.get(Hardcoded.hiveBoxKey)!.accessToken, searchText, pageNumber);
  //   // if (dataResponseModel.success)
  //   //   medicalTerminologyModel = MedicalTerminologyModel.fromJson(dataResponseModel.data);
  //   // else {
  //   //   for (int i = 0; i < dataResponseModel.data.length; i++) {
  //   //     medicalTerminologyModel.data.add(dataResponseModel.data[i]);
  //   //   }
  //   // }
  //   if (dataResponseModel.success) {
  //     if (dataResponseModel.data.isNotEmpty) {
  //       log(dataResponseModel.data.toString());
  //
  //       medicalTerminologyModel = MedicalTerminologyModel.fromJson(dataResponseModel.data);
  //
  //       log(medicalTerminologyModel.data.toString());
  //     } else {}
  //   } else {}
  //
  //   return state.copy(medicalTerminologyModel: medicalTerminologyModel);
  // }
}
