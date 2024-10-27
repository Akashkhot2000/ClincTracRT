import "dart:convert";
import 'dart:developer';

import 'package:clinicaltrac/model/error_response_model.dart';

///
class DataResponseModel {
  ///
  DataResponseModel(String strJSON) {
    final Map<String, dynamic> json = jsonDecode(strJSON) as Map<String, dynamic>;

    if (json['Error'] != null) {
      errorResponse = ErrorResponse.fromJson(json['Error']);
    } else {
      if (json['status'] != null) {
        status = json['status'] as int;
      }
      if (json['success'] != null) {
        success = json['success'] as bool;
      }

      if (json['payload'] != null) {
        data = json['payload'] ?? {};
      } else {
        data = {};
      }

      if (json['message'] != null) {
        message = json['message'] as String;
      }
    }
  }

  ///
  DataResponseModel.errorMessage(this.errorResponse, this.data);

  ///
  ErrorResponse errorResponse = ErrorResponse(errorCode: '', errorMessage: '');

  ///
  Map<String, dynamic> data = <String, dynamic>{};

  int status = 0;

  bool success = false;

  String message = '';
}
