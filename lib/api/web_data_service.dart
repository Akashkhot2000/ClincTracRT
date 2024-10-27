import 'dart:convert';

import 'package:clinicaltrac/clinician/model/common_models/update_interaction_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_upload_image_model.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_add_evaluation_req_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/view/check_offs/model/create_checkoff_request_model.dart';
import 'package:clinicaltrac/view/home/model/menu_add_remove_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_request.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/error_response_model.dart';
import 'package:clinicaltrac/model/expectionmodel.dart';
import 'package:clinicaltrac/model/photo_upload_request.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/save_journal_request_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/update_journal_model.dart';
import 'package:clinicaltrac/view/formative/models/add_Formative_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_steps_request.dart';
import 'package:clinicaltrac/view/profile/model/edit_student_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// WebDataService implements the actual body for the abstract methods mentioned
/// in [DataService]
class WebDataService extends DataService {
  static String baseurl1 = 'http://192.168.1.97/clinicaltrac';

  ///----------------------------------------------------------------------------------------------------------------------------------------------
  //// Staging Base URL
  static String baseurl = 'https://staging.clinicaltrac.net';

  //// Prod Base URL
  // static String baseurl = 'https://rt.clinicaltrac.net';
  ///-------------------------------------------------------------------------------------------------------------------------------------------------

  String apiAccessKey = "252@12#2YHD-85DA2S3DEA853=SDAS5D-IE5B4A5ASFK221";

  String apiAccessPassword = "kLXT2bSahWaon4rBK2217oEqHR5aDCCKRWf7Vx2IJGVL";

  ///-------------------------------------------------------------------------------------------------------------------------------------------------

  /// DataResponse that will indicate that the APIs cannot be called
  final DataResponseModel serviceNotAvailable = DataResponseModel.errorMessage(
    ErrorResponse(
        errorMessage:
            'Service is unavailable. Please restart the application and try again.',
        errorCode: '500'),
    <String, dynamic>{},
  );

  /// DataResponse that will be sent when there is no Internet available
  final DataResponseModel internetNotAvailableResponse =
      DataResponseModel.errorMessage(
    ErrorResponse(
        errorMessage: "Internet is not available. Kindly check.",
        errorCode: '501'),
    <String, dynamic>{},
  );

  /// DataResponse that will be sent when there is any network error
  final DataResponseModel networkError = DataResponseModel.errorMessage(
    ErrorResponse(errorMessage: "Network error occurred", errorCode: '501'),
    <String, dynamic>{},
  );

  /// API key obtained from Firebase functions.
  /// This API key is used to call all APIs to the base URL where the user is not yet logged in.
  late String apiKey = "";

  /// JWT that is set upon login
  late String jwt = "";

  ///refresh token is set upon login and use when jwt expired
  late String refreshToken = "";

  /// Expiry timestamp in milliseconds of the [apiKey]
  late int apiKeyExpiry = 0;

  /// performs the natural HTTP GET operation based on the passed relative [path],'
  /// and [queryParams]
  Future<DataResponseModel> performHTTPGET(
    String path, [
    Map<String, dynamic>? queryParams,
  ]) async {
    final bool isInternet = await isInternetAvailable();
    if (isInternet == false) {
      return internetNotAvailableResponse;
    }

    AppHelper.log('query params (if any) = ${json.encode(queryParams)}');

    final Uri url = Uri.parse(
      /*baseurl*/
      baseurl + path,
    );
    late Uri uri;

    switch (url.scheme) {
      case 'http':
        uri = Uri.http(
            "${url.host}${url.hasPort ? ':' : ''}${url.hasPort ? url.port : ''}",
            url.path,
            queryParams);
        break;
      case 'https':
        uri = Uri.https(url.host, url.path, queryParams);
        break;
    }

    final Map<String, String> headers = <String, String>{
      'X-App-Version': AppConsts.strAndroidIOSBuildVersion,
    };

    final http.Response response = await get(uri, headers: headers);

    AppHelper.log("Path $baseurl$path");
    AppHelper.log("body ${response.body}");
    AppHelper.log("${response.statusCode} $path");

    DataResponseModel dataResponse;
    switch (response.statusCode) {
      case 200:
        dataResponse = DataResponseModel(response.body);
        // retryCount = 0;
        break;
      case 409: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 401: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 400: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 412: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;

      default: //ohk
        dataResponse = networkError;
        break;
    }

    return dataResponse;
  }

  /////Testing
  Future<DataResponseModel> perTestformHTTPGET(
    String path, [
    Map<String, dynamic>? queryParams,
  ]) async {
    final bool isInternet = await isInternetAvailable();
    if (isInternet == false) {
      return internetNotAvailableResponse;
    }

    // AppHelper.log('query params (if any) = ${json.encode(queryParams)}');

    final Uri url = Uri.parse(
      /*baseurl*/
      baseurl1 + path,
    );
    late Uri uri;

    switch (url.scheme) {
      case 'http':
        uri = Uri.http(
            "${url.host}${url.hasPort ? ':' : ''}${url.hasPort ? url.port : ''}",
            url.path,
            queryParams);
        break;
      case 'https':
        uri = Uri.https(url.host, url.path, queryParams);
        break;
    }

    final Map<String, String> headers = <String, String>{
      'X-App-Version': AppConsts.strAndroidIOSBuildVersion,
    };

    final http.Response response = await get(uri, headers: headers);

    AppHelper.log("Path $baseurl$path");
    AppHelper.log("body ${response.body}");
    AppHelper.log("${response.statusCode} $path");

    DataResponseModel dataResponse;
    switch (response.statusCode) {
      case 200:
        dataResponse = DataResponseModel(response.body);
        // retryCount = 0;
        break;

      default:
        dataResponse = networkError;
        break;
    }

    return dataResponse;
  }

  /////////// Testing

  /// performs the natural HTTP POST operation based on the passed relative [path],
  /// and [queryParams] and [body]
  Future<DataResponseModel> performHTTPPOST(
      String path, Map<String, dynamic> body) async {
    return performHTTPPOSTJson(
      path,
      json.encode(body),
    );
  }

  /// performs the natural HTTP POST operation based on the passed relative [path],
  /// and [queryParams] and JSON [body]
  Future<DataResponseModel> performHTTPPOSTJson(
    String path,
    String jsonBody,
  ) async {
    // if (Auth) {

    final bool isInternet = await isInternetAvailable();
    if (isInternet == false) {
      return internetNotAvailableResponse;
    }

    // switch (authToken) {
    //   case AuthToken.bearerApiKey:
    //     // TODO: Handle this case.
    //     break;
    //   case AuthToken.bearerJWT:
    //     if (jwt.isEmpty) {
    //       return serviceNotAvailable;
    //     }
    //     break;
    //   case AuthToken.none:
    //     // TODO: Handle this case.
    //     break;
    // }

    AppHelper.log('performing request for path = $baseurl$path');
    AppHelper.log('for request body = $jsonBody');

    final Uri url = Uri.parse("$baseurl$path");

    late Uri uri;

    switch (url.scheme) {
      case 'http':
        uri = Uri.http(
          "${url.host}${url.hasPort ? ':' : ''}${url.hasPort ? url.port : ''}",
          url.path,
        );
        break;
      case 'https':
        uri = Uri.https(url.host, url.path);
        break;
    }

    final Map<String, String> headers = <String, String>{};

    final http.Response response =
        await post(uri, body: jsonBody, headers: headers);

    AppHelper.log("${response.statusCode} $path");
    AppHelper.log(response.body);
    AppHelper.log('token at post $jwt');
    AppHelper.log('ApiKey at post $apiKey');

    DataResponseModel dataResponse;
    switch (response.statusCode) {
      case 200:
        dataResponse = DataResponseModel(response.body);
        break;
      case 409: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 401: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk
      case 400:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk
      case 412:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk

      default: //ohk
        dataResponse = networkError;
        break;
    }
    return dataResponse;
  }

  /// performs the natural HTTP PUT operation based on the passed relative [path],
  /// and [body]
  Future<DataResponseModel> performHTTPPUT(
      String path, Map<String, dynamic> body) async {
    return performHTTPPUTJson(path, json.encode(body), body);
  }

  /// performs the natural HTTP PUT JSON operation based on the passed relative [path],
  /// and JSON [body]
  Future<DataResponseModel> performHTTPPUTJson(
    String path,
    String jsonBody,
    Map<String, dynamic> body,
  ) async {
    final bool isInternet = await isInternetAvailable();
    if (isInternet == false) {
      return internetNotAvailableResponse;
    }

    AppHelper.log('for request body = $jsonBody');
    AppHelper.log("Path $baseurl$path");

    final Uri url = Uri.parse(baseurl + path);
    late Uri uri;

    switch (url.scheme) {
      case 'http':
        uri = Uri.http(
          "${url.host}${url.hasPort ? ':' : ''}${url.hasPort ? url.port : ''}",
          url.path,
        );
        break;
      case 'https':
        uri = Uri.https(url.host, url.path);
        break;
    }

    final Map<String, String> headers = <String, String>{};

    final http.Response response =
        await put(uri, body: jsonBody, headers: headers);

    AppHelper.log(response.statusCode.toString());
    AppHelper.log(response.body);

    DataResponseModel dataResponse;
    switch (response.statusCode) {
      case 200:
        dataResponse = DataResponseModel(response.body);
        break;
      case 409:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk
      case 401:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk
      case 400:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk
      case 412:
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break; //ohk

      default: //ohk
        dataResponse = networkError;
        break;
    }
    return dataResponse;
  }

  /// performs the natural HTTP DELETE operation based on the passed relative [path],
  /// and [body]
  Future<DataResponseModel> performHTTPDELETE(
      String path, Map<String, dynamic> body) async {
    return performHTTPDELETEJson(path, json.encode(body), body);
  }

  /// performs the natural HTTP DELETE JSON operation based on the passed relative [path],
  /// and JSON [body]
  Future<DataResponseModel> performHTTPDELETEJson(
    String path,
    String jsonBody,
    Map<String, dynamic> body,
  ) async {
    final bool isInternet = await isInternetAvailable();
    if (isInternet == false) {
      return internetNotAvailableResponse;
    }

    // AppHelper.log('for request body = $jsonBody');
    // AppHelper.log("Path $baseurl$path");

    final Uri url = Uri.parse(baseurl + path);
    late Uri uri;

    switch (url.scheme) {
      case 'http':
        uri = Uri.http(
          "${url.host}${url.hasPort ? ':' : ''}${url.hasPort ? url.port : ''}",
          url.path,
        );
        break;
      case 'https':
        uri = Uri.https(url.host, url.path);
        break;
    }

    final Map<String, String> headers = <String, String>{};

    final http.Response response =
        await delete(uri, body: jsonBody, headers: headers);

    // AppHelper.log(response.statusCode.toString());
    // AppHelper.log(response.body);

    DataResponseModel dataResponse;
    switch (response.statusCode) {
      case 200:
        dataResponse = DataResponseModel(response.body);
        break;
      case 409: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 401: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 400: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;
      case 412: //ohk
        dataResponse = DataResponseModel(response.body);
        //AppHelper.buildErrorSnackbar(Buil, dataResponseModel.errorMessage.errorMessage),
        break;

      default: //ohk
        dataResponse = networkError;
        break;
    }
    return dataResponse;
  }

  /// Method which will return boolean if the internet is available / not available
  Future<bool> isInternetAvailable() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    //SbioaHelper.sbioaLog(connectivityResult.toString());

    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.mobile:
        return true;

      case ConnectivityResult.none:
        return false;

      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.bluetooth:
        return true;
      case ConnectivityResult.vpn:
        return false;
      case ConnectivityResult.other:
        return false;
    }
  }

  @override
  Future<DataResponseModel> login(
      String schoolCode, String userName, String password) {
    const String path = '/service/V2/authenticatestudent.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "APIACCESSKEY": apiAccessKey,
        "APIACCESSPASSWORD": apiAccessPassword,
        "SchoolCode": schoolCode,
        "UserName": userName,
        "Password": password,
      },
    );
  }

  @override
  Future<DataResponseModel> forgotPWD(String schoolCode, String email) {
    const String path = '/service/V2/forgotPassword.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "APIACCESSKEY": apiAccessKey,
        "APIACCESSPASSWORD": apiAccessPassword,
        "SchoolCode": schoolCode,
        "Email": email,
      },
    );
  }

  @override
  Future<DataResponseModel> logout(
      String userID, String accessToken, String loggedUserloginhistoryId) {
    const String path = '/service/V2/logout.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "LoggedUserloginhistoryId": loggedUserloginhistoryId
      },
    );
  }

  // @override
  // Future<DataResponseModel> getRotationList(
  //     String userID, String accessToken, String pageNo) {
  //   String path =
  //       '/service/V2/getStudentRotationList.html?AccessToken=$accessToken&UserId=$userID&PageNo=$pageNo&IsActive=1';
  //   //'https://rt.clinicaltrac.net/service/V2/getStudentRotationList.html?AccessToken=$accessToken=&UserId=$userID&PageNo=$pageNo&IsActive=1'
  //   return performHTTPGET(
  //     path,
  //     <String, dynamic>{
  //       "UserId": userID,
  //       "PageNo": pageNo,
  //       "AccessToken": accessToken
  //     },
  //   );
  // }

  @override
  Future<DataResponseModel> getRotationList(
      String userID, String accessToken, String pageNo, String isActive) {
    const String path = '/service/V2/getStudentRotationList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "PageNo": pageNo,
        "AccessToken": accessToken,
        "IsActive": isActive
      },
    );
  }

  @override
  Future<DataResponseModel> getAllRotationList(CommonRequest request) {
    const String path = '/service/V2/getStudentAllRotationList.html';
    return performHTTPGET(path, request.toJson()
        // <String, dynamic>{"UserId": userID, "PageNo": pageNo, "AccessToken": accessToken,},
        );
  }

  @override
  Future<DataResponseModel> getRotationListDemo(CommonRequest request) {
    // const String path = '/service/V2/getStudentRotationListCopy.html';
    const String path = '/service/V2/getStudentRotationList.html';
    return performHTTPGET(path, request.toJson()
        // <String, dynamic>{"UserId": userID, "PageNo": pageNo, "AccessToken": accessToken,},
        );
  }

  // @override
  // Future<DataResponseModel> getRotationListDemo(CommonRequest request) {
  //   const String path = '/service/V2/getStudentRotationList.html';
  //   return perTestformHTTPGET(path, request.toJson()
  //     // <String, dynamic>{"UserId": userID, "PageNo": pageNo, "AccessToken": accessToken,},
  //   );
  // }

  @override
  Future<DataResponseModel> changePassword(String userId, String oldPassword,
      String newPassword, String confirmPassword, String accessToken) {
    const String path = '/service/V2/changepassword.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userId,
        "OldPassword": oldPassword,
        "NewPassword": newPassword,
        "ConfirmPassword": confirmPassword,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getStudentDetails(
      String userID, String accessToken) {
    const String path = '/service/V2/getStudentDetails.html';
    return performHTTPGET(
      path,
      <String, dynamic>{"UserId": userID, "AccessToken": accessToken},
    );
  }

  @override
  Future<DataResponseModel> getCountryList(String userID, String accessToken) {
    const String path = '/service/V2/getCountryList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{"UserId": userID, "AccessToken": accessToken},
    );
  }

  @override
  Future<DataResponseModel> getStateList(
      String userID, String accessToken, String countryId) {
    const String path = '/service/V2/getStateList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "CountryId": countryId
      },
    );
  }

  @override
  Future<DataResponseModel> editStudentDetails(
      EditStudentRequest editStudentRequest) {
    const String path = '/service/V2/updateprofile.html';
    return performHTTPPUT(
      path,
      editStudentRequest.toJson(),
    );
  }

  @override
  Future<DataResponseModel> photoUpload(PhotoUploadRequest photoUploadRequest) {
    const String path = '/service/V2/updateprofileImage.html';
    return performHTTPPUT(
      path,
      photoUploadRequest.toJson(),
    );
  }

  @override
  Future<DataResponseModel> getCourseList(String userID, String accessToken) {
    const String path = '/service/V2/getCourseListByRotations.html';
    return performHTTPGET(
      path,
      <String, dynamic>{"UserId": userID, "AccessToken": accessToken},
    );
  }

  @override
  Future<DataResponseModel> getCourseTopicList(
    String userID,
    String accessToken,
    String rotationId,
  ) {
    const String path = '/service/V2/getCheckoffCourseTopics.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "RotationId": rotationId,
      },
    );
  }

  @override
  Future<DataResponseModel> getAllCourseTopicList(
    String userID,
    String accessToken,
  ) {
    const String path = '/service/V2/getCheckoffCourseTopics.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  Future<DataResponseModel> getRotationForEvalList(
      String userID, String accessToken, String isAdvanceCheckoff) {
    const String path = '/service/V2/getRotationsForEvaluation.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "isAdvanceCheckoff": isAdvanceCheckoff
      },
    );
  }

  @override
  Future<DataResponseModel> getRotationListByCourse(
      String userID,
      String accessToken,
      String pageNo,
      String isActive,
      String courseId,
      String title) {
    const String path = '/service/V2/getStudentRotationList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "PageNo": pageNo,
        "AccessToken": accessToken,
        "IsActive": isActive,
        "CourseId": courseId,
        "Title": title
      },
    );
  }

  @override
  Future<DataResponseModel> getStudActiveRotationList(
      String userID, String accessToken) {
    const String path = '/service/V2/getStudentActiveRotations.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getUserDashboardDetails(
      String userID, String accessToken) {
    const String path = '/service/V2/getStudentDashboard.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> setClockInOROut(String userID, String accessToken,
      String rotationId, String longitude, String lattitude, String type) {
    const String path = '/service/V2/performStudentClockInOut.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "RotationId": rotationId,
        "Longitude": longitude,
        "Lattitude": lattitude,
        "Type": type,
        "AccessToken": accessToken
      },
    );
  }

  @override
  Future<DataResponseModel> getDailyJournalList(
      CommonRequest dailyJournalListRequest) {
    const String path = '/service/V2/getStudentJournalList.html';
    return performHTTPGET(
      path,
      dailyJournalListRequest.toJson(),
    );
  }

  @override
  Future<DataResponseModel> getDailyJournalDetails(
      JournalDetailsRequest journalDetails) {
    const String path = '/service/V2/getStudentJournalDetails.html';
    return performHTTPGET(
      path,
      journalDetails.toJson(),
    );
  }

  @override
  Future<DataResponseModel> saveStudentJournal(
      SaveJournalRequest saveJournalRequest) {
    const String path = '/service/V2/saveStudentJournal.html';
    return performHTTPPOST(
      path,
      saveJournalRequest.toJson(),
    );
  }

  @override
  Future<DataResponseModel> updateStudentJournal(
      UpdateJournalRequest updateJournalRequest) {
    const String path = '/service/V2/updateStudentJournal.html';
    return performHTTPPUT(
      path,
      updateJournalRequest.toJson(),
    );
  }

  Future<DataResponseModel> getUserActiveRotationList(
      String userID, String accessToken) {
    const String path = '/service/V2/getStudentActiveRotations.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getRotations(
      String userID, String accessToken, String IsAll) {
    const String path = '/service/V2/getRotations.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "IsAll": IsAll,
      },
    );
  }

  // @override
  // Future<DataResponseModel> getDrInterations(
  //     CommonRequest request, ) {
  //   const String path = '/service/V2/getStudentInteractionList.html';
  //   return performHTTPGET(
  //     path,request.toJson(),
  //   );
  // }
  @override
  Future<DataResponseModel> getDrInterations(String userId, String accessToken,
      String pageNo, String searchText, String rotationID) {
    const String path = '/service/V2/getStudentInteractionList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userId,
        "AccessToken": accessToken,
        "PageNo": pageNo,
        "SearchText": searchText,
        "RotationId": rotationID
      },
    );
  }

  @override
  Future<DataResponseModel> getHospitalSiteUnit(
      String userID, String accessToken) {
    const String path = '/service/V2/getHospitalSiteUnit.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getMedicalTerminologyList(
    CommonRequest request,
    // String userID, String accessToken, String searchText, String pageNumber
  ) {
    const String path = '/service/V2/getStudentMedicalTerminology.html';
    return performHTTPGET(
      path, request.toJson(),
      // <String, dynamic>{
      //   "UserId": userID,
      //   "AccessToken": accessToken,
      //   "SearchText": searchText,
      //   "PageNo": pageNumber
      // },
    );
  }

  @override
  Future<DataResponseModel> getProcedureCountList(ProceduerCountRequest request
      // String userID,
      // String accessToken,
      // String rotationId,
      ) {
    const String path = '/service/V2/getStudentProcedureCountList.html';
    return performHTTPGET(path, request.toJson()
        // <String, dynamic>{
        //   "UserId": userID,
        //   "AccessToken": accessToken,
        //   "RotationId": rotationId,
        // },
        );
  }

  @override
  Future<DataResponseModel> getProcedureCountDetails(
      ProcedureCountDetailRequest request) {
    const String path = '/service/V2/getStudentProcedureCountDetails.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getProcedureCountStepsList(
      ProceduerCountStepsRequest request) {
    const String path = '/service/V2/getProcedureCountSteps.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getStudentProcedureList(
      StudentProceduerRequest request) {
    const String path = '/service/V2/getStudentProcedureList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getAttedance(CommonRequest request) {
    const String path = '/service/V2/getStudentAttendance.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> saveExpection(ExpectionModel expectionModel) {
    const String path = '/service/V2/saveException.html';
    return performHTTPPOST(
      path,
      expectionModel.toJson(),
    );
  }

  Future<DataResponseModel> getClinicianList(
      String userID, String accessToken, String rotationId) {
    const String path = '/service/V2/getClinicianList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "RotationId": rotationId,
      },
    );
  }

  @override
  Future<DataResponseModel> saveStudentDrInteraction(
      String userID,
      String accessToken,
      String rotationId,
      String clinicianID,
      String interactionDate,
      String hospitalsitesUnitId,
      String amountTimeSpent,
      String studentResponse) {
    const String path = '/service/V2/saveStudentInteraction.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "RotationId": rotationId,
        "ClinicianId": clinicianID,
        "InteractionDate": interactionDate,
        "HospitalSiteUnitId": hospitalsitesUnitId,
        "AmountTimeSpent": amountTimeSpent,
        "StudentResponse": studentResponse,
        "AccessToken": accessToken,
      },
    );
  }

  @override
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
  ) {
    const String path = '/service/V2/updateStudentInteraction.html';
    return performHTTPPUT(
      path,
      <String, dynamic>{
        "InteractionId": interactionID,
        "UserId": userID,
        "RotationId": rotationId,
        "ClinicianId": clinicianID,
        "InteractionDate": interactionDate,
        "HospitalSiteUnitId": hospitalsitesUnitId,
        "AmountTimeSpent": amountTimeSpent,
        "StudentResponse": studentResponse,
        "AccessToken": accessToken,
        "PointsAwarded": pointsAwarded,
      },
    );
  }

  @override
  Future<DataResponseModel> getIncident(CommonRequest request) {
    const String path = '/service/V2/getStudentIncidentList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getFormative(CommonRequest request) {
    const String path = '/service/V2/getStudentFormativeList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getDailyWeekly(CommonRequest request) {
    const String path = '/service/V2/getStudentDailyList.html';
    return performHTTPGET(path, request.toJson());
  }

  Future<DataResponseModel> getMastryEvalution(CommonRequest request) {
    const String path = '/service/V2/getStudentMasteryList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getMastryDetailDataEvalution(
      CommonRequest request) {
    const String path = '/service/V2/getStudentMasteryDetails.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getSummative(CommonRequest request) {
    const String path = '/service/V2/getStudentSummativeList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getMidtermEvaluationList(CommonRequest request) {
    const String path = '/service/V2/getStudentMidtermList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getCiEvalauionList(CommonRequest request) {
    const String path = '/service/V2/getStudentCIEvalutionList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getBriefCase(CommonRequest request) {
    const String path = '/service/V2/getStudentBriefCaseList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getSiteEvalauionList(CommonRequest request) {
    const String path = '/service/V2/getStudentSiteEvalutionList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getCheckoffsList(CommonRequest request) {
    const String path = '/service/V2/getStudentCheckoffList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addFormative(AddFormativeRequest request) {
    const String path = '/service/V2/addStudentFormative.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addSummative(AddCommonEvaluationRequest request) {
    const String path = '/service/V2/addStudentSummative.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addMidterm(AddCommonEvaluationRequest request) {
    const String path = '/service/V2/addStudentMidterm.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addDailyWeekly(AddCommonEvaluationRequest request) {
    const String path = '/service/V2/addStudentDaily.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getFormativeEvaluationdetails(
      String userID, String accessToken, String evualtionId) {
    const String path = '/service/V2/getStudentFormativeDetails.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "EvaluationId": evualtionId,
      },
    );
  }

  @override
  Future<DataResponseModel> resendSmsEval(
    String userID,
    String accessToken,
    String evualtionId,
    String type,
    String mobileNumber,
  ) {
    const String path = '/service/V2/resendEvaluationSms.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "EvaluationId": evualtionId,
        "EvaluationType": type,
        "MobileNumber": mobileNumber,
      },
    );
  }

  @override
  Future<DataResponseModel> SignOffEvaluation(
    String userID,
    String accessToken,
    String evualtionId,
    String StudentSignatureDate,
    String comments,
  ) {
    const String path = '/service/V2/studentFormativeSignoff.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "EvaluationId": evualtionId,
        "StudentSignatureDate": StudentSignatureDate,
        "StudentComment": comments
      },
    );
  }

  @override
  Future<DataResponseModel> getMenuAddRemove(
    String userID,
    String accessToken,
  ) {
    const String path = '/service/V2/menuAddRemove.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> deleteData(
    String id,
    String userID,
    String accessToken,
    String deleteType,
    String type,
  ) {
    const String path = '/service/V2/delete.html';
    return performHTTPDELETE(
      path,
      <String, dynamic>{
        "Id": id,
        "UserId": userID,
        "AccessToken": accessToken,
        "DeleteType": deleteType,
        "Type": type,
      },
    );
  }

  @override
  Future<DataResponseModel> createStudentProcedureCount(
      String userID,
      String accessToken,
      String rotationId,
      String checkoffId,
      String procedureCountTopicId,
      String pointsAssist,
      String pointsObserve,
      String pointsPerform,
      String procedureDate) {
    const String path = '/service/V2/saveStudentProcedureCount.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "RotationId": rotationId,
        "CheckoffId": checkoffId,
        "ProcedureCountTopicId": procedureCountTopicId,
        "PointsAssist": pointsAssist,
        "PointsObserve": pointsObserve,
        "PointsPerform": pointsPerform,
        "ProcedureDate": procedureDate,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getStudentCaseStudySettingList(
    CommonRequest request,
  ) {
    const String path = '/service/V2/getStudentCasestudySettings.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getStudentCaseStudyList(
    CommonRequest request,
  ) {
    const String path = '/service/V2/getStudentCasestudyList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> createCheckoff(
    CreateCheckoffRequestRequest request,
  ) {
    const String path = '/service/V2/addStudentCheckoff.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> editStudentProcedureCount(
      String userID,
      String accessToken,
      String rotationId,
      String procedureCountId,
      String procedureCountTopicId,
      String pointsAssist,
      String pointsObserve,
      String pointsPerform,
      String procedureDate) {
    const String path = '/service/V2/saveStudentProcedureCount.html';
    return performHTTPPUT(
      path,
      <String, dynamic>{
        "UserId": userID,
        "RotationId": rotationId,
        "ProcedureCountId": procedureCountId,
        "ProcedureCountTopicId": procedureCountTopicId,
        "PointsAssist": pointsAssist,
        "PointsObserve": pointsObserve,
        "PointsPerform": pointsPerform,
        "ProcedureDate": procedureDate,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> getAnnouncementList(CommonRequest request) {
    const String path = '/service/V2/getAnnouncement.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getPEFList(CommonRequest request) {
    const String path = '/service/V2/getStudentPEFList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getPEvalauionList(CommonRequest request) {
    const String path = '/service/V2/studentPEvaluationList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getFloorList(CommonRequest request) {
    const String path = '/service/V2/getStudentFloorList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addFloorTherapy(
      AddCommonEvaluationRequest request) {
    const String path = '/service/V2/addStudentFloor.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getEquipmentList(CommonRequest request) {
    const String path = '/service/V2/getStudentEquipmentList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getVolunteerList(CommonRequest request) {
    const String path = '/service/V2/getStudentVolunteerList.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> addVolunteerList(
      AddCommonEvaluationRequest request) {
    const String path = '/service/V2/addStudentVolunteer.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getWebRedirect(CommonRequest request) {
    const String path = '/webRedirect.html';
    return performHTTPGET(path, request.toJson());
  }

  @override
  Future<DataResponseModel> copyAndEmailSendEval(
      CommonCopyUrlAndSendEmailRequest commonCopyUrlAndSendEmailRequest) {
    const String path = '/service/V2/getCopyURL.html';
    return performHTTPGET(path, commonCopyUrlAndSendEmailRequest.toJson());
  }

  @override
  Future<DataResponseModel> changeScheduleHospitalSite(CommonRequest request) {
    const String path = '/service/V2/changeScheduleHospitalSite.html';
    return performHTTPPOST(path, request.toJson());
  }

  @override
  Future<DataResponseModel> getHospitalSiteList(
    String userID,
    String accessToken,
  ) {
    const String path = '/service/V2/getHospitalSitesList.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
      },
    );
  }

//// Clinician & School both APP Services ////

//// Login as userBase
  @override
  Future<DataResponseModel> userBaseLogin(
      String schoolCode, String userName, String password, String userType) {
    const String path = '/service/V2/authenticateUser.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "APIACCESSKEY": apiAccessKey,
        "APIACCESSPASSWORD": apiAccessPassword,
        "SchoolCode": schoolCode,
        "UserName": userName,
        "Password": password,
        "UserType": userType,
      },
    );
  }

  // /API to get DR interaction for userBsae
  @override
  Future<DataResponseModel> getDrInterationsList(
      String userId,
      String accessToken,
      String pageNo,
      String searchText,
      String rotationID,
      String userType) {
    const String path = '/service/V2/getStudentInteractionListCopy.html';
    return performHTTPGET(
      path,
      <String, dynamic>{
        "UserId": userId,
        "AccessToken": accessToken,
        "PageNo": pageNo,
        "SearchText": searchText,
        "RotationId": rotationID,
        "UserType": userType,
      },
    );
  }

  ///forgotNewPWD

  Future<DataResponseModel> userForgotPassword(
      String schoolCode, String email) {
    const String path = '/service/V2/forgotUserPassword.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "APIACCESSKEY": apiAccessKey,
        "APIACCESSPASSWORD": apiAccessPassword,
        "SchoolCode": schoolCode,
        "Email": email,
      },
    );
  }

  //
  @override
  Future<DataResponseModel> userChangePassword(
      String userId,
      String userType,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      String accessToken) {
    const String path = '/service/V2/changeUserPassword.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userId,
        "UserType": userType,
        "OldPassword": oldPassword,
        "NewPassword": newPassword,
        "ConfirmPassword": confirmPassword,
        "AccessToken": accessToken,
      },
    );
  }

  @override
  Future<DataResponseModel> userLogout(String userID, String accessToken,
      String userType, String loggedUserloginhistoryId) {
    const String path = '/service/V2/logoutUser.html';
    return performHTTPPOST(
      path,
      <String, dynamic>{
        "UserId": userID,
        "AccessToken": accessToken,
        "UserType": userType,
        "LoggedUserloginhistoryId": loggedUserloginhistoryId
      },
    );
  }

  /// Daily journal list
  @override
  Future<DataResponseModel> getUserDailyJournalList(
      CommonRequest dailyJournalListRequest) {
    const String path = '/service/V2/getUserJournalList.html';
    return performHTTPGET(
      path,
      dailyJournalListRequest.toJson(),
    );
  }

  /// Update Daily journal
  @override
  Future<DataResponseModel> updateUserJournal(
      UpdateJournalRequest updateJournalRequest) {
    const String path = '/service/V2/updateUserJournal.html';
    return performHTTPPUT(
      path,
      updateJournalRequest.toJson(),
    );
  }

  /// Get Student Detail List
  @override
  Future<DataResponseModel> getStudentDetailList(
      CommonRequest dailyJournalListRequest) {
    const String path = '/service/V2/studentDetails.html';
    return performHTTPGET(
      path,
      dailyJournalListRequest.toJson(),
    );
  }

  /// Get Clinician Rotation Detail List
  @override
  Future<DataResponseModel> getClinicianRotationDetailList(
      CommonRequest dailyJournalListRequest) {
    const String path = '/service/V2/getClinicianRotationList.html';
    return performHTTPGET(
      path,
      dailyJournalListRequest.toJson(),
    );
  }

  /// Get Rank Dropdown List
  @override
  Future<DataResponseModel> getRankDropdownList(CommonRequest request) {
    const String path = '/service/V2/rankList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Get Student Dropdown List
  @override
  Future<DataResponseModel> getStudentDropdownList(CommonRequest request) {
    const String path = '/service/V2/studentList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Menu add and remove
  @override
  Future<DataResponseModel> getUserMenuAddRemove(CommonRequest request) {
    const String path = '/service/V2/userMenuAddRemove.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Dr.Interaction journal list
  @override
  Future<DataResponseModel> getUserDrInteractionList(CommonRequest request) {
    const String path = '/service/V2/getUserDrInteractionList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Update user interaction
  @override
  Future<DataResponseModel> updateUserInteraction(
      UpdateInteractionRequestModel updateInteractionRequest) {
    const String path = '/service/V2/updateUserInteraction.html';
    return performHTTPPUT(
      path,
      updateInteractionRequest.toJson(),
    );
  }

  /// Student Attendence Module API
  /// Get Pending And All Attendance List
  @override
  Future<DataResponseModel> getPendingAndViewAttendanceList(
      CommonRequest request) {
    const String path = '/service/V2/getUserAttendance.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Get Clinician Student Wise Attendance List
  @override
  Future<DataResponseModel> getClinicianStudentAllAttendanceList(
      CommonRequest request) {
    const String path = '/service/V2/getClinicianStutendAttendanceList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// Approve Student Attendance
  @override
  Future<DataResponseModel> approveStudentAttendance(
      UpdateInteractionRequestModel updateInteractionRequest) {
    const String path = '/service/V2/approveStudentAttendance.html';
    return performHTTPPUT(
      path,
      updateInteractionRequest.toJson(),
    );
  }

  /// profile module Api
  /// get userCountryList Api
  @override
  Future<DataResponseModel> getUserCountryList(CommonRequest request) {
    const String path = '/service/V2/getCountryList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// get getUserStateList Api
  @override
  Future<DataResponseModel> getUserStateList(CommonRequest request) {
    const String path = '/service/V2/getStateList.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// get getUserDetails Api
  @override
  Future<DataResponseModel> getUserDetailData(CommonRequest request) {
    const String path = '/service/V2/getUserDetails.html';
    return performHTTPGET(
      path,
      request.toJson(),
    );
  }

  /// edit userdetails
  @override
  Future<DataResponseModel> editUserDetails(EditUserRequest editUserRequest) {
    const String path = '/service/V2/updateUserProfile.html';
    return performHTTPPUT(
      path,
      editUserRequest.toJson(),
    );
  }

  /// upload userimage
  @override
  Future<DataResponseModel> UserphotoUpload(
      UserPhotoUploadRequest userPhotoUploadRequest) {
    const String path = '/service/V2/updateUserProfileImage.html';
    return performHTTPPUT(
      path,
      userPhotoUploadRequest.toJson(),
    );
  }
}
