import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/get_country_list_action.dart';
import 'package:clinicaltrac/redux/action/get_student_details.dart';
import 'package:clinicaltrac/redux/app_state.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/view/home/view/home_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/model/country_list_model.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:clinicaltrac/view/profile/view/profile.dart';
import 'package:flutter/material.dart';

/// Connector for [HomePageScreen]
class ProfileScreenConnector extends StatelessWidget {
  const ProfileScreenConnector({super.key});

  /// page change callback

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return StoreConnector<AppState, ProfileScreenViewModel>(
      model: ProfileScreenViewModel(),
      builder: (BuildContext context, ProfileScreenViewModel vm) => ProfileScreen(
        studentDetailsResponse: vm.studentDetailsResponse,
        countryList: vm.countryList,
        getCountryList: vm.getCountryList,
        getStudentDetails: vm.getStudentDetails,
        isEditProfile: vm.isProfileEditable,
      ),
    );
  }
}

class ProfileScreenViewModel extends BaseModel<AppState> {
  /// Constructor for [ProfileScreenViewModel]
  ProfileScreenViewModel();

  ///userLoginResponse
  late StudentDetailsResponse studentDetailsResponse;
  late CountryList countryList;
  late VoidCallback getStudentDetails;
  late VoidCallback getCountryList;
  late bool isProfileEditable;

  ProfileScreenViewModel.build(
      {required this.studentDetailsResponse,
      required this.getCountryList,
      required this.getStudentDetails,
      required this.countryList,
      required this.isProfileEditable})
      : super(
          equals: <dynamic>[studentDetailsResponse, countryList, isProfileEditable],
        );

  @override
  ProfileScreenViewModel fromStore() => ProfileScreenViewModel.build(
      studentDetailsResponse: state.studentDetailsResponse,
      countryList: state.countryList,
      isProfileEditable: state.isProfileEditable,
      getStudentDetails: () => store.dispatch(getStudentDetailsAction()),
      getCountryList: () => store.dispatch(getCountryListAction()));
}
