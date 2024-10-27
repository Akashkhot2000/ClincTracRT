// import 'package:dashboard/widgets/common_app_bar.dart';
// import 'package:dashboard/widgets/customTextField.dart';
// import 'package:dashboard/widgets/customdropdpwn.dart';
import 'dart:developer';

import 'package:clinicaltrac/clinician/common_widgets/common_bottom_sheet.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_country_list_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_request_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_state_list_model.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_upload_image_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_profile_photo.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';

import '../../login_screen/login_bottom_widget.dart';

class Profile extends StatefulWidget {
  // UserDetailData? userDetailData;
  const Profile({
    Key? key,
    // this.userDetailData,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController imageLink = TextEditingController();
  TextEditingController base64Image = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();

  final fnameFocusNode = FocusNode();
  final lnameFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final add1FocusNode = FocusNode();
  final add2FocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final zipFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final stateFocusNode = FocusNode();

  List<UserCountryListData> userCountryDropdownList = <UserCountryListData>[];
  List<UserCountryListData> userAllCountryDropdownList =
      <UserCountryListData>[];
  List<UserStateListData> userStateDropdownList = <UserStateListData>[];
  List<UserStateListData> userAllStateDropdownList = <UserStateListData>[];
  UserCountryListData selectedUserCountryValue = new UserCountryListData();
  UserStateListData selectedUserStateValue = new UserStateListData();
  UserDetailData userDetailData = new UserDetailData();

  String selectedCountry = '';
  String selectedCountryId = '';
  String selectedState = '';
  String selectedStateId = '';
  String localPath = 'assets/images/default_profile_photo.png';

  @override
  void initState() {
    userCountryListData();
    getLoggedUserDetails();
    super.initState();
    setValue();
  }

  Future<void> userCountryListData() async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    return userDatRepo.getUserCountryList(request,
        (UserCountryListModel userCountryListModel) {
      setState(() {
        userCountryDropdownList = userCountryListModel.data!;
        userAllCountryDropdownList = userCountryListModel.data!;
      });
      return null;
    }, () {}, context);
  }

  void userStateListData(String selectCountryId) async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
      countryId: selectCountryId,
    );
    return userDatRepo.getUserStateList(request,
        (UserStateListModel userStateListModel) {
      setState(() {
        userStateDropdownList = userStateListModel.data!;
        userAllStateDropdownList = userStateListModel.data!;

        if (userStateDropdownList.isNotEmpty) {
          selectedUserStateValue = userStateDropdownList[0];
        } else {
          selectedUserStateValue = UserStateListData(
            stateId: 'defaultId',
            title: 'No data available',
          );
        }
      });
      return null;
    }, () {}, context);
  }

  Future<void> getLoggedUserDetails() async {
    setState(() {
      isLoading = true; // Show loader
    });
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    await userDatRepo.getUserDetailData(request,
        (UserDetailModel userDetailModel) {
      userDetailData = userDetailModel.data!;
      setValue();
      setState(() {
        isLoading = false; // Hide loader after data is loaded
      });
    }, () {
      setState(() {
        isLoading = false; // Hide loader on error
      });
    }, context);
  }

  void setValue() {
    firstName.text = userDetailData.loggedUserFirstName != null
        ? userDetailData.loggedUserFirstName!
        : "";
    lastName.text = userDetailData.loggedUserLastName != null
        ? userDetailData.loggedUserLastName!
        : "";
    email.text = userDetailData.loggedUserEmail != null
        ? userDetailData.loggedUserEmail!
        : "";
    userName.text = userDetailData.loggedUserName != null
        ? userDetailData.loggedUserName!
        : "";
    addressLine1.text = userDetailData.loggedUserAddress1 != null
        ? userDetailData.loggedUserAddress1!
        : "";
    addressLine2.text = userDetailData.loggedUserAddress2 != null
        ? userDetailData.loggedUserAddress2!
        : "";
    city.text = userDetailData.city != null ? userDetailData.city! : "";
    zipCode.text =
        userDetailData.zipCode != null ? userDetailData.zipCode! : "";
    selectedUserCountryValue.title = userDetailData.countryName != null
        ? userDetailData.countryName!
        : 'India';
    selectedUserStateValue.title =
        userDetailData.stateName != null ? userDetailData.stateName! : "";
    selectedCountryId =
        userDetailData.countryId != null ? userDetailData.countryId! : '100';
    selectedStateId =
        userDetailData.stateId != null ? userDetailData.stateId! : "";
    if (userDetailData.loggedUserProfile != null) {
      imageLink.text = userDetailData.loggedUserProfile! != null
          ? userDetailData.loggedUserProfile!
          : localPath;
    } else {
      localPath = 'assets/default-user.png';
    }
  }

  searchCountryData(String text) {
    if (text.isNotEmpty) {
      userCountryDropdownList = <UserCountryListData>[];
      for (int i = 0; i < userAllCountryDropdownList.length; i++) {
        if (userAllCountryDropdownList[i]
            .title!
            .toLowerCase()
            .contains(text.toLowerCase())) {
          userCountryDropdownList.add(userAllCountryDropdownList[i]);
        }
      }
    } else {
      userCountryDropdownList = <UserCountryListData>[];
      userCountryDropdownList.addAll(userAllCountryDropdownList);
    }
    setState(() {
      userCountryDropdownList;
 
    });
  }

  searchStateData(String text) {
    if (text.isNotEmpty) {
      userStateDropdownList = <UserStateListData>[];
      for (int i = 0; i < userAllStateDropdownList.length; i++) {
        if (userAllStateDropdownList[i]
            .title!
            .toLowerCase()
            .contains(text.toLowerCase())) {
          userStateDropdownList.add(userAllStateDropdownList[i]);
        }
      }
    } else {
      userStateDropdownList = <UserStateListData>[];
      userStateDropdownList.addAll(userAllStateDropdownList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        isBackArrow: true,
        appBarColor: Colors.white,
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
        // isEdit: widget.isEditProfile ? false : true,
        onEditTap: () {
          setState(() {
            // widget.isEditProfile = !widget.isEditProfile;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20.0),
          child: Visibility(
            visible: isLoading,
            child: Padding(
              padding: EdgeInsets.only(top: globalHeight * 0.25),
              child: common_loader(
                durationInSec: 5,
                size: 50,
              ),
            ),
            replacement: Column(
              children: [
                commonProfilePhoto(
                  isEdit: true,
                  radius: 50,
                  ImageLink: imageLink,
                  LocalPath: localPath,
                  isLocal: store
                      .state.userLoginResponse.data.loggedUserProfile.isEmpty,
                  base64Image: base64Image,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
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
                                  // readOnly: !widget.isEditProfile,
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
                                  // readOnly: !widget.isEditProfile,
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
                          onTap: () {
                            // AppConsts.loggedUserId == 1;
                          },
                          child: CommonTextfield(
                            inputText: "Email",
                            focusNode: emailFocusNode,
                            autoFocus: false,
                            readOnly: true,
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
                            // readOnly: !widget.isEditProfile,
                            hintText: 'Enter user name',
                            textEditingController: userName,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: AppConsts.userType == '1',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Divider(
                          thickness: 1,
                        ),
                        // SizedBox(
                        //   width: 340.w,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 3.w, top: 1.h, bottom: 1.h),
                        //     child: Text(
                        //       'Address',
                        //       style: TextStyle(
                        //         color: Color(0xFF1A203D),
                        //         fontSize: 18.sp,
                        //         fontFamily: 'Poppins',
                        //         fontWeight: FontWeight.w600,
                        //         height: 0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
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
                              // readOnly: !widget.isEditProfile,
                              hintText: 'Enter address line 1',
                              textEditingController: addressLine1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Visibility(
                        //   visible: AppConsts.loggedUserId == 1,
                        //   child:
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
                              // readOnly: !widget.isEditProfile,
                              hintText: 'Enter address line 2',
                              textEditingController: addressLine2,
                            ),
                          ),
                          // ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ExpansionWidget<UserCountryListData>(
                          inputText: 'Country',
                          hintText: selectedUserCountryValue.title != ''
                              ? selectedUserCountryValue.title!
                              : "Select Country",
                          // selectedUserCountryValue.title != "Select Country" ? "Select Country" : '',

                          // enabled: selectAllCourseTopic.toString().isEmpty
                          //     ? true
                          //     : false,
                          // textColor: Colors.black,
                          textColor: selectedUserCountryValue.title
                                  .toString()
                                  .isNotEmpty
                              ? Colors.black
                              : Color(Hardcoded.greyText),
                          isSearch: true,
                          searchWidget: Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Material(
                              color: Colors.white,
                              child: CommonSearchTextfield(
                                focusNode: countryFocusNode,
                                hintText: 'Search here',
                                autoFocus: false,
                                textEditingController: countryController,
                                fillColor: Color(0x1413AD5D),
                                sufix: Container(
                                  transform:
                                      Matrix4.translationValues(0.0, 0.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      countryController.text = '';
                                      countryController.clear();
                                      searchCountryData("");
                                      // FocusManager.instance.primaryFocus!
                                      //     .unfocus();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Color.fromARGB(255, 98, 105, 121),
                                    ),
                                  ),
                                ),
                                onChanged: (String text) {
                                  setState(() {
                                    searchCountryData(text);
                                  });
                                },
                              ),
                            ),
                          ),

                          OnSelection: (value) {
                            setState(() {
                              UserCountryListData c =
                                  value as UserCountryListData;
                              selectedUserCountryValue = c;
                              // singleCourseTopicList.clear();
                              selectedCountryId =
                                  selectedUserCountryValue.countryId.toString();
                              selectedCountry =
                                  selectedUserCountryValue.title.toString();
                              countryController.text = '';
                              countryController.clear();
                              searchCountryData("");
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              userStateListData(selectedCountryId);
                            });

                            log("id---------${selectedUserCountryValue.countryId}");
                          },
                          items: List.of(
                            userCountryDropdownList.map(
                                (item) => DropdownItem<UserCountryListData>(
                                    value: item,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          left: globalWidth * 0.06,
                                          right: globalWidth * 0.06,
                                          bottom: 8.0),
                                      child: Text(
                                        item.title!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ))),
                          ),
                        ),
                        ExpansionWidget<UserStateListData>(
                          // isReset: false,
                          key: ValueKey<String>(
                              selectedUserStateValue.stateId ?? ''),
                          inputText: 'State',
                          hintText: selectedUserStateValue.title != null
                              ? selectedUserStateValue.title!
                              : 'Select state',

                          // enabled: selectAllCourseTopic.toString().isEmpty
                          //     ? true
                          //     : false,
                          textColor: selectedUserCountryValue.title
                                  .toString()
                                  .isNotEmpty
                              ? Colors.black
                              : Color(Hardcoded.greyText),
                          isSearch: true,
                          searchWidget: Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Material(
                              color: Colors.white,
                              child: CommonSearchTextfield(
                                focusNode: stateFocusNode,
                                hintText: 'Search here',
                                autoFocus: false,
                                textEditingController: stateController,
                                fillColor: Color(0x1413AD5D),
                                sufix: Container(
                                  transform:
                                      Matrix4.translationValues(0.0, 0.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      stateController.text = '';
                                      stateController.clear();
                                      searchStateData("");
                                      // FocusManager.instance.primaryFocus!
                                      //     .unfocus();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Color.fromARGB(255, 98, 105, 121),
                                    ),
                                  ),
                                ),
                                onChanged: (String text) {
                                  setState(() {
                                    searchStateData(text);
                                  });
                                },
                              ),
                            ),
                          ),
                          OnSelection: (value) {
                            setState(() {
                              UserStateListData firstState =
                                  value as UserStateListData;
                              selectedUserStateValue = firstState;
                              countryController.text = '';
                              countryController.clear();
                              searchCountryData("");
                              //   // singleCourseTopicList.clear();
                              //   selectedStateId =
                              //       selectedUserStateValue.stateId.toString();
                              //   slectedState =
                              //       selectedUserStateValue.title.toString();
                            });
                            log("id---------${selectedUserStateValue.stateId}");
                          },
                          items: List.of(
                            userStateDropdownList.map(
                              (item) {
                                String text = item.title.toString();
                                return DropdownItem<UserStateListData>(
                                  value: item,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0,
                                        left: globalWidth * 0.06,
                                        right: globalWidth * 0.06,
                                        bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          text,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                                    // readOnly: !widget.isEditProfile,
                                    hintText: 'Enter city name',
                                    textEditingController: city,
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
                                  focusNode: zipFocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Zip Code",
                                    autoFocus: false,
                                    focusNode: zipFocusNode,
                                    // readOnly: !widget.isEditProfile,
                                    hintText: 'Enter zip code',
                                    textEditingController: zipCode,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CommonTextfield(
                          readOnly: true,
                          inputText: "Country",
                          keyboardType: TextInputType.none,
                          autoFocus: false,
                          hintText: selectedUserCountryValue.title != ''
                              ? selectedUserCountryValue.title!
                              : "Select Country",
                          textEditingController: countryController,
                          sufix: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (BuildContext context) {
                                  return common_bottom_sheet<
                                      UserCountryListData>(
                                    hintText: 'se',
                                    inputText: 'select Country',
                                    listItem: List.of(
                                        userCountryDropdownList.map((item) {
                                      return BottomsheetItem<
                                          UserCountryListData>(
                                        value: item,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0,
                                              left: globalWidth * 0.06,
                                              right: globalWidth * 0.06,
                                              bottom: 8.0),
                                          child: Text(
                                            item.title!,
                                            maxLines: 1,
                                          ),
                                        ),
                                      );
                                    })),
                                    isSearch: true,
                                    searchWidget: Padding(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Material(
                                        color: Colors.white,
                                        child: CommonSearchTextfield(
                                          focusNode: countryFocusNode,
                                          hintText: 'Search here',
                                          autoFocus: false,
                                          textEditingController:
                                              countryController,
                                          fillColor: Color(0x1413AD5D),
                                          sufix: Container(
                                            transform:
                                                Matrix4.translationValues(
                                                    0.0, 0.0, 0.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                countryController.text = '';
                                                countryController.clear();
                                                searchCountryData("");
                                                // FocusManager
                                                //     .instance.primaryFocus!
                                                //     .unfocus();
                                                log(countryController.text);
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Color.fromARGB(
                                                    255, 98, 105, 121),
                                              ),
                                            ),
                                          ),
                                          onChanged: (String text) {
                                            setState(() {
                                              searchCountryData(text);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    OnSelection: (value) {
                                      setState(() {
                                        UserCountryListData c =
                                            value as UserCountryListData;
                                        selectedUserCountryValue = c;
                                        selectedCountryId =
                                            selectedUserCountryValue.countryId
                                                .toString();
                                        selectedCountry =
                                            selectedUserCountryValue.title
                                                .toString();
                                        countryController.text = '';
                                        countryController.clear();
                                        searchCountryData("");
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        userStateListData(selectedCountryId);
                                      });
                                      log("id---------${selectedUserCountryValue.countryId}");
                                    },
                                  );
                                });
                          },
                        )
                    
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.085,
        // color: Colors.amber,
        elevation: 0,
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          title: 'Update',
          textcolor: Colors.white,
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (editProfileValidation()) {
              if (base64Image.text != '') await uploadPhoto();
              await editUserDetails();
            } else {
              save.error();
              Future.delayed(Duration(seconds: 2), () {
                save.reset();
              });
            }
          },
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
    );
  }

  uploadPhoto() async {
    final DataService dataService = locator();
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    UserPhotoUploadRequest photoUploadRequest = UserPhotoUploadRequest(
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userType: AppConsts.userType,
        image: base64Image.text);

    try {
      DataResponseModel dataResponseModel =
          await dataService.UserphotoUpload(photoUploadRequest);
      if (dataResponseModel.status == 200) {
      } else {}
      // Handle the response as needed
      // ...
      log('${base64Image.text}');
    } catch (error) {
      // Handle errors, e.g., log them or show a message to the user
      print('Error uploading photo: $error');
    }
    log('${base64Image.text}');
  }

  Future<void> editUserDetails() async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    EditUserRequest editUserRequest = EditUserRequest(
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userType: AppConsts.userType,
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text,
      userName: userName.text,
      // address1: addressLine1.text,
      // address2: addressLine2.text,
      // countryId: selectedCountryId,
      // stateId: selectedStateId,
      // city: city.text,
      // zipCode: zipCode.text,
    );

    return userDatRepo.updateUserDetailData(editUserRequest, () {
      setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          save.reset();
          getLoggedUserDetails();
        }).then((value) {
          common_alert_pop(context, 'Successfully Updated.',
              'assets/images/success_Icon.svg', () {
            // setState(() {
            Navigator.pushReplacementNamed(
              context,
              Routes.bodySwitcher,
              arguments: BodySwitcherData(
                  initialPage: Bottom_navigation_control.profile),
            );
            // });
            // Navigator.pop(context);
          });
        });
      });
    }, () {
      save.error();
      Future.delayed(Duration(seconds: 2), () {
        save.reset();
      });
    }, context);
  }

  bool editProfileValidation() {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]*$');
    final RegExp zipPattern = RegExp(r'^\d{5}(?:[-\s]\d{4})?$');

    if (AppConsts.userType == '0') {
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
      if (email.text.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please enter email");
        return false;
      }
      if (!emailRegExp.hasMatch(email.text)) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter email in correct format");
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

      if (addressLine1.text.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please enter Address Line 1");
        return false;
      }
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
    } else {
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
      if (email.text.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please enter email");
        return false;
      }
      if (!emailRegExp.hasMatch(email.text)) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter email in correct format");
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
    }
    return true;
  }
}
