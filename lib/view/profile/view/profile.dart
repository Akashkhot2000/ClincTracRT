import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_drop_down.dart';
import 'package:clinicaltrac/common/common_profile_photo.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/photo_upload_request.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:clinicaltrac/view/profile/model/country_list_model.dart';
import 'package:clinicaltrac/view/profile/model/edit_student_request_model.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:clinicaltrac/view/profile/model/state_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../common/routes.dart';
import '../../body_switcher/vm_conector/body_switcher_vm_conector.dart';

class ProfileScreen extends StatefulWidget {
  final StudentDetailsResponse studentDetailsResponse;
  final CountryList countryList;
  final VoidCallback getCountryList;
  final VoidCallback getStudentDetails;
  bool isEditProfile;

  ProfileScreen(
      {required this.studentDetailsResponse,
      required this.countryList,
      required this.getCountryList,
      required this.getStudentDetails,
      required this.isEditProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ///controllers
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController imageLink = TextEditingController();
  // TextEditingController localPath = TextEditingController();
  TextEditingController base64Image = TextEditingController();
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  String localPath = 'assets/images/default_profile_photo.png';
  bool isOldObs = true;
  bool isNewObs = true;
  bool isConfirmObs = true;
  bool isinitialeEdit = false;
  List<String> CountryList = [
    'Item2',
  ];
  String? selectedCountry;
  List<String> stateList = [
    'Item1',
  ];
  String? selectedState;
  String? countryCode;
  String? stateCode;
  StateList stateListi = StateList(data: []);
  List<String> stateCodeList = [];

  void fetchStateList(String countryCode) async {
    stateCodeList = [];
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.getStateList(
        box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        box.get(Hardcoded.hiveBoxKey)!.accessToken,
        countryCode);
    stateListi = StateList.fromJson(dataResponseModel.data);
    List<String> temp = [];
    for (var cnt in stateListi.data) {
      temp.add(cnt.stateName);
      stateCodeList.add(cnt.stateId);
    }
    setState(() {
      stateList = temp;
      if (selectedCountry != widget.studentDetailsResponse.data.countryName) {
        selectedState = stateList[0];
        stateCode = stateCodeList[
            stateList.indexWhere((element) => element == selectedState)];
      }
    });
  }

  void setValue() {
    firstName.text = widget.studentDetailsResponse.data.loggedUserFirstName;
    lastName.text = widget.studentDetailsResponse.data.loggedUserLastName;
    email.text = widget.studentDetailsResponse.data.loggedUserEmail;
    userName.text = widget.studentDetailsResponse.data.loggedUserName;
    addressLine1.text = widget.studentDetailsResponse.data.loggedUserAddress1;
    addressLine2.text = widget.studentDetailsResponse.data.loggedUserAddress2;
    city.text = widget.studentDetailsResponse.data.city;
    zipCode.text = widget.studentDetailsResponse.data.zipCode;
    selectedCountry = widget.studentDetailsResponse.data.countryName != ''
        ? widget.studentDetailsResponse.data.countryName
        : 'India';
    CountryList = [selectedCountry!];
    selectedState = widget.studentDetailsResponse.data.stateName;
    stateList = [selectedState!];
    countryCode = widget.studentDetailsResponse.data.countryId != ''
        ? widget.studentDetailsResponse.data.countryId
        : '100';
    stateCode = widget.studentDetailsResponse.data.stateId;
    if (widget.studentDetailsResponse.data.loggedUserProfile.isNotEmpty) {
      imageLink.text = widget.studentDetailsResponse.data.loggedUserProfile;
    } else {
      localPath = 'assets/images/default_profile_photo.png';
    }

    List<String> temp1 = [];
    int cx = 0;
    for (var cnt in widget.countryList.data) {
      cx++;
      temp1.add('${cnt.countryName}');
    }
    setState(() {
      CountryList = temp1;
    });
    //CountryList = temp;
    fetchStateList(countryCode!);
  }

  File? croppedFile;
  String urlImage = "";
  String imgPath = "";
  bool isRemoveImage = false;
  bool isProfileImgChange = false;

  @override
  void initState() {
    widget.getCountryList();
    widget.getStudentDetails();
    editStudentDetails();
    setValue();
    isinitialeEdit = widget.isEditProfile;
    super.initState();
  }

  final fnameFocusNode = FocusNode();
  final lnameFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final add1FocusNode = FocusNode();
  final add2FocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final zipFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
            arguments:
                BodySwitcherData(initialPage: Bottom_navigation_control.home));
        return false;
      },
      child: Scaffold(
        appBar: CommonAppBar(
          appBarColor: Colors.white,
          isBackArrow: false,
          isCenterTitle: true,
          titles: Text(
            // widget.isEditProfile ? "Edit Profile" : "Profile",
            "Profile",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.home));
          },
          isEdit: widget.isEditProfile ? false : true,
          onEditTap: () {
            setState(() {
              widget.isEditProfile = !widget.isEditProfile;
            });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          height: globalHeight * 0.085,
          // color: Colors.amber,
          elevation: 0,
          child: CommonRoundedLoadingButton(
            controller: save,
            width: globalWidth * 0.9,
            title: 'Save',
            textcolor: Colors.white,
            onTap: () {
              FocusScope.of(context).unfocus();
              if (editProfileValidation()) {
                if (base64Image.text != '') uploadPhoto();
                editStudentDetails();
              }
              save.reset();
              if (isinitialeEdit) {
                widget.isEditProfile = true;
              }
            },
            color: Color(Hardcoded.primaryGreen),
          ),
        ),
        backgroundColor: Color(Hardcoded.white),
        body: NoInternet(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 144,
                  //   child: Stack(
                  //     alignment: Alignment(0.20, 0.75),
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: const EdgeInsets.only(bottom: 22),
                  //         child: Align(
                  //           alignment: Alignment.bottomCenter,
                  //           // child: Container(
                  //           child: base.isNotEmpty
                  //               ? Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(60),
                  //               ),
                  //               image: DecorationImage(
                  //                 image: AssetImage(
                  //                     'assets/images/user_placeholder.png'),
                  //               ),
                  //             ),
                  //             height: 110,
                  //             width: 110,
                  //             child: Container(
                  //               width: 110.0,
                  //               height: 110.0,
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(
                  //                   60.0,
                  //                 ),
                  //                 child: FadeInImage(
                  //                   placeholder: const AssetImage(
                  //                       'assets/images/user_placeholder.png'),
                  //                   image: MemoryImage(base64Decode(base)),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //               : Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(60),
                  //               ),
                  //               image: DecorationImage(
                  //                 image: AssetImage(
                  //                     'assets/images/user_placeholder.png'),
                  //               ),
                  //             ),
                  //             height: 110,
                  //             width: 110,
                  //             child: Container(
                  //               width: 110.0,
                  //               height: 110.0,
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(60.0),
                  //                 child: FadeInImage(
                  //                   placeholder: AssetImage(
                  //                       'assets/images/user_placeholder.png'),
                  //                   image: NetworkImage(urlImage != null
                  //                       ? urlImage == ''
                  //                       ? 'https://toppng.com/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png'
                  //                       : urlImage
                  //                       : 'https://toppng.com/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: () {
                  //           //pickimage();
                  //           _showPermissionAlertDialog();
                  //         },
                  //         child:CircleAvatar(
                  //           radius: 20,
                  //           backgroundColor: Color(Hardcoded.primaryGreen),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: SvgPicture.asset(
                  //               'assets/images/editPhoto.svg',
                  //               height: 60,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  commonProfilePhoto(
                      isEdit: widget.isEditProfile,
                      ImageLink: imageLink,
                      LocalPath: localPath,
                      radius: 60,
                      isLocal: store.state.userLoginResponse.data
                          .loggedUserProfile.isEmpty,
                      base64Image: base64Image),
                  const SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'User Information',
                  //   textAlign: TextAlign.start,
                  //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16,
                  //       color: Color(Hardcoded.primaryGreen)),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: IOSKeyboardAction(
                            label: 'DONE',
                            focusNode: fnameFocusNode,
                            focusActionType: FocusActionType.done,
                            onTap: () {},
                            child: CommonTextfield(
                              inputText: "First Name",
                              autoFocus: false,
                              focusNode: fnameFocusNode,
                              readOnly: !widget.isEditProfile,
                              hintText: 'Enter first name',
                              textEditingController: firstName,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: IOSKeyboardAction(
                            label: 'DONE',
                            focusNode: lnameFocusNode,
                            focusActionType: FocusActionType.done,
                            onTap: () {},
                            child: CommonTextfield(
                              inputText: "Last Name",
                              autoFocus: false,
                              focusNode: lnameFocusNode,
                              readOnly: !widget.isEditProfile,
                              hintText: 'Enter last name',
                              textEditingController: lastName,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: emailFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "Email",
                        focusNode: emailFocusNode,
                        autoFocus: false,
                        readOnly: !widget.isEditProfile,
                        hintText: 'Enter email',
                        textEditingController: email,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: userNameFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "User Name",
                        autoFocus: false,
                        focusNode: userNameFocusNode,
                        readOnly: !widget.isEditProfile,
                        hintText: 'Enter user name',
                        textEditingController: userName,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  // Text(
                  //   'Address Information',
                  //   textAlign: TextAlign.start,
                  //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16,
                  //       color: Color(Hardcoded.primaryGreen)),
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: add1FocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "Address Line 1",
                        autoFocus: false,
                        focusNode: add1FocusNode,
                        readOnly: !widget.isEditProfile,
                        hintText: 'Enter address line 1',
                        textEditingController: addressLine1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: add2FocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "Address Line 2",
                        autoFocus: false,
                        focusNode: add2FocusNode,
                        readOnly: !widget.isEditProfile,
                        hintText: 'Enter address line 2',
                        textEditingController: addressLine2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CoomonDropDown(
                      inputText: "Country",
                      items: CountryList,
                      selectedValue: selectedCountry,
                      title: "Select country",
                      isEdit: widget.isEditProfile,
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                          countryCode = widget.countryList.data
                              .firstWhere((element) =>
                                  element.countryName == selectedCountry)
                              .countryId;
                        });
                        fetchStateList(countryCode!);
                      },
                      width: globalWidth * 0.895),
                  const SizedBox(
                    height: 15,
                  ),
                  CoomonDropDown(
                      inputText: "State",
                      items: stateList,
                      selectedValue: selectedState,
                      title: "Select state",
                      isEdit: widget.isEditProfile,
                      onChanged: (value) {
                        setState(() {
                          selectedState = value!;
                          stateCode = stateCodeList[stateList.indexWhere(
                              (element) => element == selectedState)];
                          // log(stateCode.toString());
                        });
                      },
                      width: globalWidth * 0.895),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: IOSKeyboardAction(
                            label: 'DONE',
                            focusNode: cityFocusNode,
                            focusActionType: FocusActionType.done,
                            onTap: () {},
                            child: CommonTextfield(
                              inputText: "City",
                              autoFocus: false,
                              focusNode: cityFocusNode,
                              readOnly: !widget.isEditProfile,
                              hintText: 'Enter city',
                              textEditingController: city,
                            ),
                          ),
                        ),
                        // CommonDropDown(context, stateList, selectedState, "State", widget.isEditProfile, (value) {
                        //   setState(() {
                        //     selectedState = value!;
                        //
                        //     stateCode = stateCodeList[stateList.indexWhere((element) => element == selectedState)];
                        //   });
                        // }, 200),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: IOSKeyboardAction(
                            label: 'DONE',
                            focusNode: zipFocusNode,
                            focusActionType: FocusActionType.done,
                            onTap: () {},
                            child: CommonTextfield(
                              inputText: "Zip Code",
                              autoFocus: false,
                              focusNode: zipFocusNode,
                              readOnly: !widget.isEditProfile,
                              hintText: 'Enter zip code',
                              textEditingController: zipCode,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     /*Expanded(
                  //     child: CommonRoundedLoadingButton(
                  //       controller: cancel,
                  //       width: globalWidth * 0.4,
                  //       title: 'Cancel',
                  //       textcolor: Color(0xFF01A750),
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //       },
                  //       color: Color(Hardcoded.white),
                  //     ),
                  //   ),*/
                  //     Expanded(
                  //       child: CommonRoundedLoadingButton(
                  //         controller: save,
                  //         width: globalWidth * 1,
                  //         title: 'Save',
                  //         textcolor: Colors.white,
                  //         onTap: () {
                  //           FocusScope.of(context).unfocus();
                  //           if (editProfileValidation()) {
                  //             if (base64Image.text != '') uploadPhoto();
                  //             editStudentDetails();
                  //           }
                  //           save.reset();
                  //           if (isinitialeEdit) {
                  //             widget.isEditProfile = true;
                  //           }
                  //         },
                  //         color: Color(Hardcoded.primaryGreen),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadPhoto() async {
    final DataService dataService = locator();
    PhotoUploadRequest photoUploadRequest = PhotoUploadRequest(
        userId: widget.studentDetailsResponse.data.loggedUserId,
        accessToken: widget.studentDetailsResponse.data.accessToken,
        image: base64Image.text);
    // log(photoUploadRequest.toJson().toString());
    DataResponseModel dataResponseModel =
        await dataService.photoUpload(photoUploadRequest);
    widget.getStudentDetails();
  }

  editStudentDetails() async {
    final DataService dataService = locator();
    EditStudentRequest editStudentRequest = EditStudentRequest(
        userId: widget.studentDetailsResponse.data.loggedUserId,
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        userName: userName.text,
        address1: addressLine1.text,
        address2: addressLine2.text,
        countryId: countryCode!,
        stateId: stateCode!,
        city: city.text,
        zipCode: zipCode.text,
        accessToken: widget.studentDetailsResponse.data.accessToken);
    // log(editStudentRequest.toJson().toString());
    final DataResponseModel dataResponseModel =
        await dataService.editStudentDetails(editStudentRequest);
    if (dataResponseModel.success) {
      Future.delayed(const Duration(seconds: 1), () {}).then((value) {
        AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
        //widget.getStudentDetails();
        // setState(() {
        //   widget.getStudentDetails();
        // });
        Future.delayed(const Duration(seconds: 4), () {
          widget.getStudentDetails();
        });
      });
      // Future.delayed(const Duration(seconds: 5), () {}).then((value) {
      //   AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
      //   widget.getStudentDetails();
      //   // Future.delayed(const Duration(seconds: 1), () {
      //   //   //store.dispatch(removeProfileEditable());
      //   //   //Navigator.pop(context);
      //   // });
      // });
    } else {
      Future.delayed(const Duration(seconds: 1), () {}).then((value) =>
          AppHelper.buildErrorSnackbar(
              context, dataResponseModel.errorResponse.errorMessage));
    }
  }

  bool editProfileValidation() {
    // const Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    // final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]*$');
    final RegExp zipPattern = RegExp(r'^\d{5}(?:[-\s]\d{4})?$');
    // final RegExp address1Pattern = RegExp(r'^\d+\s+[a-zA-Z]+(\s+[a-zA-Z]+)*$');
    // RegExp address2Pattern = RegExp(r'^[a-zA-Z\d\s\-#,\.]+');

    if (firstName.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter first name");
      return false;
    }
    if (firstName.text.length <= 2) {
      AppHelper.buildErrorSnackbar(
          context, "Minimum 3 characters required in first name");
      return false;
    }
    if (!nameRegex.hasMatch(firstName.text)) {
      AppHelper.buildErrorSnackbar(
        context,
        "Please enter a valid first name",
      );
      return false;
    }
    if (lastName.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter last name");
      return false;
    }
    if (lastName.text.length <= 2) {
      AppHelper.buildErrorSnackbar(
          context, "Minimum 3 characters required in last name");
      return false;
    }
    if (!nameRegex.hasMatch(lastName.text)) {
      AppHelper.buildErrorSnackbar(
        context,
        "Please enter a valid last name",
      );
      return false;
    }
    if (userName.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter user name");
      return false;
    }
    if (userName.text.length <= 5) {
      AppHelper.buildErrorSnackbar(context, "Minimum 6 characters required");
      return false;
    }
    if (email.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter email");
      return false;
    }
    if (!emailRegExp.hasMatch(email.text)) {
      AppHelper.buildErrorSnackbar(
          context, "Please enter email in correct format");
      return false;
    }
    if (addressLine1.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter Address Line 1");
      return false;
    }
    // if (!address1Pattern.hasMatch(addressLine1.text)) {
    //   AppHelper.buildErrorSnackbar(context, "Please enter valid Address Line 1");
    //   return false;
    // }
    // if (!address2Pattern.hasMatch(addressLine2.text)) {
    //   AppHelper.buildErrorSnackbar(context, "Please enter valid Address Line 2");
    //   return false;
    // }
    // if (addressLine2.text.isEmpty) {
    //   AppHelper.buildErrorSnackbar(context, "Please enter Address line 2");
    //   return false;
    // }
    if (selectedCountry!.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select country");
      return false;
    }
    if (city.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter city");
      return false;
    }
    if (city.text.length <= 2) {
      AppHelper.buildErrorSnackbar(context, "Minimum 3 characters required");
      return false;
    }
    if (!nameRegex.hasMatch(city.text)) {
      AppHelper.buildErrorSnackbar(
        context,
        "Please enter a valid city",
      );
      return false;
    }
    if (selectedState!.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select state");
      return false;
    }
    if (zipCode.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter zip code");
      return false;
    }
    if (!zipPattern.hasMatch(zipCode.text)) {
      AppHelper.buildErrorSnackbar(
        context,
        "Please enter a valid zipcode",
      );
      return false;
    }
    return true;
  }
}
