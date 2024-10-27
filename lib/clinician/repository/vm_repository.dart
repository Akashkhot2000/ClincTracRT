import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/model/common_models/update_interaction_request_model.dart';
import 'package:clinicaltrac/clinician/model/dropdown_models/rank_dropdown_list_model.dart';
import 'package:clinicaltrac/clinician/model/dropdown_models/student_dropdown_list_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_country_list_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_state_list_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_upload_image_model.dart';
import 'package:clinicaltrac/clinician/model/student_models/student_detail_list_model.dart';
import 'package:clinicaltrac/clinician/model/student_models/student_pending_view_attendance_model.dart';
import 'package:clinicaltrac/clinician/model/universal_rotation_journal_list.dart';
import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_dr_interaction_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_menu_add_remove_model.dart';
import 'package:clinicaltrac/clinician/utils/hive_handler.dart';
import 'package:clinicaltrac/clinician/view/clini_dashboard/model/userResp_model.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_bottom_widget.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/update_journal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../hive/user_login_response_hive.dart';

class UserDatRepo {
  Future<void> userLogin(
      String schoolCode,
      String userName,
      String password,
      String userType,
      Function? Function(UserLoginResponseModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.userBaseLogin(
      schoolCode,
      userName,
      password,
      userType,
    );
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();

      final UserLoginResponseModel userLoginResponse =
          UserLoginResponseModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userLoginResponse);
    } else {
      EasyLoading.dismiss();
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  Future<void> forgotPWD(
      String schoolCode,
      String email,
      String userType,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.userForgotPassword(
      schoolCode,
      email,
    );
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      successCallback();
    } else {
      EasyLoading.dismiss();
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////ohk

  Future<void> changeUserPassword(
      String userId,
      String userType,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      String accessToken,
      Function successCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.userChangePassword(
      userId,
      userType,
      oldPassword,
      newPassword,
      confirmPassword,
      accessToken,
    );
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      Future.delayed(const Duration(seconds: 1), () {}).then((value) =>
          AppHelper.buildErrorSnackbar(context, dataResponseModel.message));
      successCallback();
    } else {
      EasyLoading.dismiss();

      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////ohk

  Future<void> logOutUser(
      String userId,
      String accessToken,
      String userType,
      String loggedUserloginhistoryId,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.userLogout(
        userId, accessToken, userType, loggedUserloginhistoryId);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      successCallback();
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  Future<SMRotationListStudentJournal> getJournalRotationlistAction() async {
    final DataService dataService = locator();
    UserLoginResponseHive? userLoginResponseHive =
        await HiveHandler.getUserData();

    final DataResponseModel dataResponseModel = await dataService.getRotations(
        userLoginResponseHive!.loggedUserId,
        userLoginResponseHive.accessToken,
        '');
    return SMRotationListStudentJournal.fromJson(dataResponseModel.data);
  } ////ohk

  ///Course list for rotation dropdown///
  Future<void> courseList(
      String userId,
      String accessToken,
      Function? Function(CourseListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.getCourseList(
      userId,
      accessToken,
    );
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final CourseListModel courseListModel = CourseListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(courseListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  /// Daily Journal Module
  ///Get User daily journal///
  Future<void> dailyJournalList(
      CommonRequest request,
      Function? Function(DailyJournalListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserDailyJournalList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final DailyJournalListModel dailyJournalListModel =
          DailyJournalListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(dailyJournalListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  ///put User daily journal///
  Future<void> updateUserDailyJournal(
      UpdateJournalRequest updateJournalRequest,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.updateUserJournal(updateJournalRequest);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      // final DailyJournalListModel dailyJournalListModel = DailyJournalListModel.fromJson(
      //   dataResponseModel.data,
      // );
      successCallback.call();
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  ///Get Student Detail List///
  Future<void> studentDetailList(
      CommonRequest request,
      Function? Function(StudentDetailListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getStudentDetailList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final StudentDetailListModel studentDetailListModel =
          StudentDetailListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(studentDetailListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  ///Get Clinician Rotation Detail List///
  Future<void> clinicianRotationList(
      CommonRequest request,
      Function? Function(ClinicianRotationListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getClinicianRotationDetailList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final ClinicianRotationListModel clinicianRotationListModel =
          ClinicianRotationListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(clinicianRotationListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  ///Get Rank Dropdown List///
  Future<void> rankDropdownList(
      CommonRequest request,
      Function? Function(RankDropdownListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getRankDropdownList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final RankDropdownListModel rankDropdownListModel =
          RankDropdownListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(rankDropdownListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  }

  ///osm

  ///Get Student Dropdown List///
  Future<void> studentDropdownList(
      CommonRequest request,
      Function? Function(StudentDropdownListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getStudentDropdownList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final StudentDropdownListModel studentDropdownListModel =
          StudentDropdownListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(studentDropdownListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  }

  ///Get User add remove///
  Future<void> userMenuAddRemove(
      CommonRequest request,
      Function? Function(UserMenuAddRemoveModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserMenuAddRemove(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final UserMenuAddRemoveModel userMenuAddRemoveModel =
          UserMenuAddRemoveModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userMenuAddRemoveModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  }

  ///osm

  /// Dr.Interaction Module
  ///Get User Dr.Interaction///
  Future<void> drInteractionList(
      CommonRequest request,
      Function? Function(UserDrInteractionListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserDrInteractionList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final UserDrInteractionListModel userDrInteractionListModel =
          UserDrInteractionListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userDrInteractionListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  ///put User daily journal///
  Future<void> updateUserDrInteraction(
      UpdateInteractionRequestModel updateInteractionRequestModel,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.updateUserInteraction(updateInteractionRequestModel);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      successCallback.call();
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

  /// Student Attendence Module API
  /// Get Pending And All Attendance List
  Future<void> pendingAndViewAttendanceList(
      CommonRequest request,
      Function? Function(StudentPendingViewAttenListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getPendingAndViewAttendanceList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final StudentPendingViewAttenListModel
          studentPendingAndAllAttenListModel =
          StudentPendingViewAttenListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(studentPendingAndAllAttenListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////osm

// user profile Module API
  /// Get country List
  Future<void> getUserCountryList(
      CommonRequest request,
      Function? Function(UserCountryListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserCountryList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final UserCountryListModel userCountryListModel =
          UserCountryListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userCountryListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////oak

// user profile Module API
  /// Get state List
  Future<void> getUserStateList(
      CommonRequest request,
      Function? Function(UserStateListModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserStateList(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final UserStateListModel userStateListModel = UserStateListModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userStateListModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////oak

// user profile Module API
  /// Get UserDetails
  Future<void> getUserDetailData(
      CommonRequest request,
      Function? Function(UserDetailModel data) successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getUserDetailData(request);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      final UserDetailModel userDetailModel = UserDetailModel.fromJson(
        dataResponseModel.data,
      );
      successCallback.call(userDetailModel);
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  }

  /// edit UserDetails
  Future<void> updateUserDetailData(
      EditUserRequest editUserRequest,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.editUserDetails(editUserRequest);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      // final DailyJournalListModel dailyJournalListModel = DailyJournalListModel.fromJson(
      //   dataResponseModel.data,
      // );
      successCallback.call();
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////oak

  /// edit UserDetails
  Future<void> uploadUserImage(
      UserPhotoUploadRequest userPhotoUploadRequest,
      Function successCallback,
      Function errorCallback,
      BuildContext context) async {
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.UserphotoUpload(userPhotoUploadRequest);
    if (dataResponseModel.status == 200) {
      EasyLoading.dismiss();
      // final DailyJournalListModel dailyJournalListModel = DailyJournalListModel.fromJson(
      //   dataResponseModel.data,
      // );
      successCallback.call();
    } else {
      errorCallback();
      AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
  } ////oak
}
