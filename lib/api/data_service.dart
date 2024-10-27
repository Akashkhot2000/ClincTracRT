import 'package:clinicaltrac/clinician/model/common_models/update_interaction_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_upload_image_model.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/model/common_add_evaluation_req_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/expectionmodel.dart';
import 'package:clinicaltrac/model/photo_upload_request.dart';
import 'package:clinicaltrac/view/check_offs/model/create_checkoff_request_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/save_journal_request_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/update_journal_model.dart';
import 'package:clinicaltrac/view/formative/models/add_Formative_model.dart';
import 'package:clinicaltrac/view/home/model/menu_add_remove_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_steps_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_request.dart';
import 'package:clinicaltrac/view/profile/model/edit_student_request_model.dart';

/// Declare all the apis
abstract class DataService {
  /// Checks if the service is ready to make necessary API calls.

  ///Login user
  Future<DataResponseModel> login(
      String schoolCode, String userName, String password);

  ///Forgot PWD
  Future<DataResponseModel> forgotPWD(
    String schoolCode,
    String email,
  );

  Future<DataResponseModel> logout(
    String userID,
    String accessToken,
    String loggedUserloginhistoryId,
  );

  Future<DataResponseModel> getRotationList(
      String userID, String accessToken, String pageNo, String isActive);

  Future<DataResponseModel> getRotationListDemo(CommonRequest request);

  ///API to get all rotation list
  Future<DataResponseModel> getAllRotationList(CommonRequest request);

  ///API to change Password
  Future<DataResponseModel> changePassword(String userId, String oldPassword,
      String newPassword, String confirmPassword, String accessToken);

  ///API to get Student Details
  Future<DataResponseModel> getStudentDetails(
      String userId, String accessToken);

  ///API to fetch Country List
  Future<DataResponseModel> getCountryList(String userId, String accessToken);

  ///API to fetch State List
  Future<DataResponseModel> getStateList(
      String userId, String accessToken, String countryId);

  ///API to Edit Student Details
  Future<DataResponseModel> editStudentDetails(
      EditStudentRequest editStudentRequest);

  ///API to Upload Photo
  Future<DataResponseModel> photoUpload(PhotoUploadRequest photoUploadRequest);

  ///API to get course list for rotation
  Future<DataResponseModel> getCourseList(
    String userID,
    String accessToken,
  );

  Future<DataResponseModel> getCourseTopicList(
    String userID,
    String accessToken,
    String rotationId,
  );

  Future<DataResponseModel> getAllCourseTopicList(
    String userID,
    String accessToken,
  );

  Future<DataResponseModel> getRotationForEvalList(
      String userID, String accessToken, String isAdvanceCheckoff);

  ///API to get course list for rotation
  Future<DataResponseModel> getRotationListByCourse(
      String userID,
      String accessToken,
      String pageNo,
      String isActive,
      String courseId,
      String title);

  ///API to get stud active rotation list for home
  Future<DataResponseModel> getStudActiveRotationList(
      String userID, String accessToken);

  ///API to get course list for rotation
  Future<DataResponseModel> getUserDashboardDetails(
    String userID,
    String accessToken,
  );

  Future<DataResponseModel> setClockInOROut(String userID, String accessToken,
      String rotationId, String longitude, String lattitude, String type);

  ///API to get Daily Journal List
  Future<DataResponseModel> getDailyJournalList(
      CommonRequest dailyJournalListRequest);

  ///API to get Journal Details
  Future<DataResponseModel> getDailyJournalDetails(
      JournalDetailsRequest journalDetailsRequest);

  ///API to save Student Journal
  Future<DataResponseModel> saveStudentJournal(
      SaveJournalRequest saveJournalRequest);

  ///API to update Student Journal
  Future<DataResponseModel> updateStudentJournal(
      UpdateJournalRequest updateJournalRequest);

  ///API to rotations for Student Journal
  Future<DataResponseModel> getRotations(
      String userId, String accessToken, String IsAll);

  ///API to get DR interaction for Student

  Future<DataResponseModel> getDrInterations(String userId, String accessToken,
      String pageNo, String searchText, String rotationId);

  // Future<DataResponseModel> getDrInterations(CommonRequest request);

  ///API to rotations for Student Journal
  Future<DataResponseModel> getHospitalSiteUnit(
      String userId, String accessToken);

  /// API to get medical terminology

  Future<DataResponseModel> getMedicalTerminologyList(CommonRequest request
      // String userID, String accessToken, String searchText, String pageNumber
      );

  /// Get Procedure Count List
  Future<DataResponseModel> getProcedureCountList(
    ProceduerCountRequest request,
    // String userID, String accessToken, String rotationId
  );

  /// Get Procedure Count Detail
  Future<DataResponseModel> getProcedureCountDetails(
      ProcedureCountDetailRequest request);

  /// Get Procedure Count Steps
  Future<DataResponseModel> getProcedureCountStepsList(
      ProceduerCountStepsRequest request);

  /// Get Student Procedure List
  Future<DataResponseModel> getStudentProcedureList(
      StudentProceduerRequest request);

  ///Get Clinician List
  Future<DataResponseModel> getClinicianList(
      String userID, String accessToken, String rotationId);

  ///Get Clinician List
  Future<DataResponseModel> saveStudentDrInteraction(
      String userID,
      String accessToken,
      String rotationId,
      String clinicianID,
      String interactionDate,
      String hospitalsitesUnitId,
      String amountTimeSpent,
      String studentResponse);

  ///Get Clinician List
  Future<DataResponseModel> editStudentDrInteraction(
    String interactionID,
    String userID,
    String accessToken,
    String rotationId,
    String clinicianID,
    String interactionDate,
    String hospitalsitesUnitId,
    String amountTimeSpent,
    String studentResponse,
    String pointsAwarded,
  );

  ///Api to get Attendance List
  Future<DataResponseModel> getAttedance(CommonRequest request);

  Future<DataResponseModel> saveExpection(ExpectionModel expectionModel);

  ///Api to get Icident List
  Future<DataResponseModel> getIncident(CommonRequest request);

  ///Api to get Formative List
  Future<DataResponseModel> getFormative(CommonRequest request);

  ///Api to get daily weekly List
  Future<DataResponseModel> getDailyWeekly(CommonRequest request);

  ///Api to get MastryEvalution
  Future<DataResponseModel> getMastryEvalution(CommonRequest request);
  Future<DataResponseModel> getMastryDetailDataEvalution(CommonRequest request);

  ///Api to get brief Case
  Future<DataResponseModel> getBriefCase(CommonRequest request);

  ///Api to get daily weekly List
  Future<DataResponseModel> getSummative(CommonRequest request);

  ///Api to get midterm evaluationList
  Future<DataResponseModel> getMidtermEvaluationList(CommonRequest request);

  Future<DataResponseModel> getCiEvalauionList(CommonRequest request);

  ///Api to get site evaluationList
  Future<DataResponseModel> getSiteEvalauionList(CommonRequest request);

  ///Api to get checkoffs list
  Future<DataResponseModel> getCheckoffsList(CommonRequest request);

  Future<DataResponseModel> addFormative(AddFormativeRequest request);

  Future<DataResponseModel> addSummative(AddCommonEvaluationRequest request);

  Future<DataResponseModel> addMidterm(AddCommonEvaluationRequest request);

  Future<DataResponseModel> addDailyWeekly(AddCommonEvaluationRequest request);

  Future<DataResponseModel> getFormativeEvaluationdetails(
      String userID, String accessToken, String evualtionId);

  Future<DataResponseModel> resendSmsEval(String userID, String accessToken,
      String evualtionId, String type, String mobileNumber);

  Future<DataResponseModel> SignOffEvaluation(String userID, String accessToken,
      String evualtionId, String StudentSignatureDate, String comments);

  Future<DataResponseModel> getMenuAddRemove(String userID, String accessToken);

  Future<DataResponseModel> deleteData(String id, String userID,
      String accessToken, String deleteType, String type);

  Future<DataResponseModel> createStudentProcedureCount(
      String userID,
      String accessToken,
      String rotationId,
      String checkoffId,
      String procedureCountTopicId,
      String pointsAssist,
      String pointsObserve,
      String pointsPerform,
      String procedureDate);

  Future<DataResponseModel> getStudentCaseStudySettingList(
    CommonRequest request,
    // String userID, String accessToken, String rotationId
  );

  Future<DataResponseModel> getStudentCaseStudyList(
    CommonRequest request,
  );

  Future<DataResponseModel> createCheckoff(
    CreateCheckoffRequestRequest request,
  );

  Future<DataResponseModel> editStudentProcedureCount(
      String userID,
      String accessToken,
      String rotationId,
      String procedureCountId,
      String procedureCountTopicId,
      String pointsAssist,
      String pointsObserve,
      String pointsPerform,
      String procedureDate);

  Future<DataResponseModel> getAnnouncementList(CommonRequest request);

  Future<DataResponseModel> getPEFList(CommonRequest request);

  Future<DataResponseModel> getPEvalauionList(CommonRequest request);

  Future<DataResponseModel> getFloorList(CommonRequest request);

  Future<DataResponseModel> addFloorTherapy(AddCommonEvaluationRequest request);

  Future<DataResponseModel> getEquipmentList(CommonRequest request);

  Future<DataResponseModel> getVolunteerList(CommonRequest request);

  Future<DataResponseModel> getWebRedirect(CommonRequest request);

  Future<DataResponseModel> copyAndEmailSendEval(
      CommonCopyUrlAndSendEmailRequest commonCopyUrlAndSendEmailRequest);

  Future<DataResponseModel> changeScheduleHospitalSite(CommonRequest request);

  Future<DataResponseModel> getHospitalSiteList(
    String userID,
    String accessToken,
  );

  //// Clinician & School both APP Services ////

  /// Login as userType
  Future<DataResponseModel> userBaseLogin(
      String schoolCode, String userName, String password, String userType);

  ///API to get DR interaction for userBsae
  Future<DataResponseModel> getDrInterationsList(
      String userId,
      String accessToken,
      String pageNo,
      String searchText,
      String rotationId,
      String userType);

  ///Forgot  new PWD
  Future<DataResponseModel> userForgotPassword(
    String schoolCode,
    String email,
  );

  ///API to change Password
  Future<DataResponseModel> userChangePassword(
      String userId,
      String userType,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      String accessToken);

  Future<DataResponseModel> userLogout(String userID, String accessToken,
      String userType, String loggedUserloginhistoryId);

  Future<DataResponseModel> getUserDailyJournalList(
      CommonRequest dailyJournalListRequest);

  Future<DataResponseModel> updateUserJournal(
      UpdateJournalRequest updateJournalRequest);

  Future<DataResponseModel> getStudentDetailList(
      CommonRequest dailyJournalListRequest);

  /// Get Clinician Rotation Detail List
  Future<DataResponseModel> getClinicianRotationDetailList(
      CommonRequest dailyJournalListRequest);

  /// Get Rank Dropdown List
  Future<DataResponseModel> getRankDropdownList(CommonRequest request);

  /// Get Student Dropdown List
  Future<DataResponseModel> getStudentDropdownList(CommonRequest request);

  /// Menu add and remove
  Future<DataResponseModel> getUserMenuAddRemove(CommonRequest request);

  /// Dr.Interaction journal list
  Future<DataResponseModel> getUserDrInteractionList(CommonRequest request);

  /// Update user interaction
  Future<DataResponseModel> updateUserInteraction(
      UpdateInteractionRequestModel updateInteractionRequest);

  /// Student Attendence Module API
  /// Get Pending And All Attendance List
  Future<DataResponseModel> getPendingAndViewAttendanceList(
      CommonRequest request);

  /// Get Clinician Student Wise Attendance List
  Future<DataResponseModel> getClinicianStudentAllAttendanceList(
      CommonRequest request);

  /// Approve Student Attendance
  Future<DataResponseModel> approveStudentAttendance(
      UpdateInteractionRequestModel updateInteractionRequest);

  /// profile module Api
  /// get userContryList Api
  Future<DataResponseModel> getUserCountryList(CommonRequest request);

  /// get userStateList Api
  Future<DataResponseModel> getUserStateList(CommonRequest request);

  /// get userDetails Api
  Future<DataResponseModel> getUserDetailData(CommonRequest request);

  /// edit userDetails Api
  Future<DataResponseModel> editUserDetails(EditUserRequest editUserRequest);

  ///upload image user
   Future<DataResponseModel> UserphotoUpload( UserPhotoUploadRequest userPhotoUploadRequest);
}
