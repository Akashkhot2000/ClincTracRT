import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_models/hospital_site_list_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ChangeHospitalSiteBottomSheet extends StatefulWidget {
  ChangeHospitalSiteBottomSheet({
    Key? key,
    required this.userId,
    required this.accessToken,
    required this.rotationId,
    required this.isClockIn,
    required this.hospitalSiteId,
    required this.hospitalSiteTitle,
  }) : super(key: key);
  final userId;
  final accessToken;
  final rotationId;
  final isClockIn;
  final hospitalSiteId;
  final String hospitalSiteTitle;

  @override
  State<ChangeHospitalSiteBottomSheet> createState() =>
      _ChangeHospitalSiteBottomSheetState();
}

class _ChangeHospitalSiteBottomSheetState
    extends State<ChangeHospitalSiteBottomSheet> {
  String selectHospitalSite = '';
  // String? hintString = 'Select course topic';
  // String selectedHospitalSite = '';
  String hospitalSiteId = '';

  // List<String> hospitalSiteList = [];
  // List<String> allhospitalSiteList = [];
  HospitalSiteListResponse hospitalSiteListResponse =
      HospitalSiteListResponse(data: <HospitalSiteData>[]);
  TextEditingController hospitalSiteController = TextEditingController();
  TextEditingController searchHospitalSite = TextEditingController();
  RoundedLoadingButtonController notify = RoundedLoadingButtonController();
  List<HospitalSiteData> singleHospitalSiteList = <HospitalSiteData>[];
  List<HospitalSiteData> allHospitalSiteList = <HospitalSiteData>[];
  HospitalSiteData selectedHospitalSiteValue = new HospitalSiteData();

  searchCourseTopic(String coursetext) {
    if (coursetext.isNotEmpty) {
      singleHospitalSiteList = <HospitalSiteData>[];
      singleHospitalSiteList.clear();
      // log("Search--------------${coursetext}");
      for (int i = 0; i < allHospitalSiteList.length; i++) {
        if (allHospitalSiteList[i]
            .title!
            .toLowerCase()
            .contains(coursetext.toLowerCase())) {
          singleHospitalSiteList.add(allHospitalSiteList[i]);
        }
      }
    } else {
      singleHospitalSiteList.clear();
      // log("Search--------------${coursetext}");
      singleHospitalSiteList = <HospitalSiteData>[];
      singleHospitalSiteList.addAll(allHospitalSiteList);
    }
    setState(() {});
  }

  Future<void> getHospitalSiteDataList() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getHospitalSiteList(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
    );
    HospitalSiteListResponse hospitalSiteListResponse =
        HospitalSiteListResponse.fromJson(dataResponseModel.data);
    setState(() {
      singleHospitalSiteList = hospitalSiteListResponse.data!;
      allHospitalSiteList = hospitalSiteListResponse.data!;
    });
    // log("${dataResponseModel.data}");
  }

  @override
  void initState() {
    selectHospitalSite = widget.hospitalSiteTitle.isNotEmpty ? "${widget.hospitalSiteTitle}": selectHospitalSite;
    getHospitalSiteDataList();
    log("${widget.rotationId}");
    super.initState();
    log("${widget.rotationId}");
  }

  final hospitalSiteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        // color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
        height: globalHeight * 0.55,
        child: Stack(
          children: [
            Padding(
             padding: EdgeInsets.only( top: globalHeight * 0.40,),
              child: Center(
                child: CommonRoundedLoadingButton(
                  controller: notify,
                  title: "Save",
                  textcolor: Color(Hardcoded.white),
                  color: Color(Hardcoded.primaryGreen),
                  width: MediaQuery.of(context).size.width - 40,
                  onTap: () async {
                    if (selectHospitalSite.isEmpty) {
                      Navigator.pop(context);
                      selectHospitalSite.isEmpty
                          ? AppHelper.buildErrorSnackbar(
                              context, "Please select hospital --------site")
                          : AppHelper.buildErrorSnackbar(
                              context, "Please select hospital --------site");
                      return false;
                    } else {
                      final DataService dataService = locator();
                      CommonRequest request = CommonRequest(
                        accessToken: widget.accessToken,
                        userId: widget.userId,
                        RotationId: widget.rotationId,
                        isClockIn: widget.isClockIn.toString(),
                        hospitalSiteId: hospitalSiteId.isEmpty
                            ? widget.hospitalSiteId : hospitalSiteId.toString(),
                      );
                      final DataResponseModel dataResponseModel =
                          await dataService.changeScheduleHospitalSite(request);
                      // log("Message--------${dataResponseModel.success}");
                      // log("Data-------${dataResponseModel.data}");
                      if (dataResponseModel.success) {
                        notify.success();
                        Future.delayed(const Duration(seconds: 1), () async {
                          Navigator.pop(context);
                          // await  widget.pullToRefresh();
                          setState(() {
                            Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                                arguments: BodySwitcherData(
                                  initialPage: Bottom_navigation_control.rotation,
                                ));
                              common_alert_pop(
                                  context,
                                  'Hospital Site Change\nSuccessfully',
                                  'assets/images/success_Icon.svg',
                                      () {
                                    Navigator.pop(context);
                                  });
                          });
                          // AppHelper.buildErrorSnackbar(context, "${dataResponseModel.message}");
                        });
                      } else {
                        notify.error();
                        Future.delayed(const Duration(seconds: 1), () {
                          notify.reset();
                          Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                              arguments: BodySwitcherData(
                                initialPage: Bottom_navigation_control.rotation,
                              ));
                          AppHelper.buildErrorSnackbar(context, "${dataResponseModel.message}");
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Schedule Hospital Site",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/images/close_modal.svg',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: ExpansionWidget<HospitalSiteData>(
                      inputText: "Select Hospital Site",
                      hintText: selectHospitalSite.toString().isNotEmpty
                          ? selectHospitalSite.toString()
                          : "Select hospital site",
                      // enabled: selectAll.toString().isEmpty ? true : false,
                      textColor: selectHospitalSite.toString().isNotEmpty
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
                            focusNode: hospitalSiteFocusNode,
                            hintText: 'Search here',
                            autoFocus: false,
                            textEditingController: hospitalSiteController,
                            fillColor: Color(0x1413AD5D),
                            sufix: Container(
                              transform:
                                  Matrix4.translationValues(0.0, 0.0, 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  hospitalSiteController.text = '';
                                  hospitalSiteController.clear();
                                  searchCourseTopic("");
                                  // FocusManager.instance.primaryFocus!
                                  //     .unfocus();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Color.fromARGB(255, 98, 105, 121),
                                ),
                              ),
                            ),
                            onChanged: (String coursetext) {
                              searchCourseTopic(coursetext);
                            },
                          ),
                        ),
                      ),
                      OnSelection: (value) {
                        setState(() {
                          HospitalSiteData c = value as HospitalSiteData;
                          selectedHospitalSiteValue = c;
                          selectHospitalSite = selectedHospitalSiteValue.title!;
                          hospitalSiteId =
                              selectedHospitalSiteValue.hospitalSiteId!;
                          hospitalSiteController.text = '';
                          hospitalSiteController.clear();
                          // searchCourseTopic("");
                        });
                        // log("id---------${hospitalSiteId}");
                        // log("Course Topic --- ${selectedCourseValue.topicId} ===== ${selectedCourseValue.title}");
                      },
                      items: List.of(singleHospitalSiteList.map(
                        (item) => DropdownItem<HospitalSiteData>(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black,
                                    )),
                          ),
                        ),
                      ))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
