import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/equipment/model/equipment_list_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EquipmentListScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;

  EquipmentListScreen(
      {super.key, required this.userLoginResponse, required this.rotation});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotfound = false;
  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<EquipmentListData> equipmentListData = [];

  void getEquipmentList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest Request = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId);
      final DataResponseModel dataResponseModel =
          await dataService.getEquipmentList(Request);

      // log(dataResponseModel.data.toString() + "SiteEval Data");
      EquipmentListModel equipmentListModel =
          EquipmentListModel.fromJson(dataResponseModel.data);
      // log(equipmentListModel.pager.totalRecords.toString() + "Equipment Data");
      lastpage =
          (int.parse(equipmentListModel.pager.totalRecords.toString()) / 10)
              .ceil();
      if (equipmentListModel.pager.totalRecords == '0') {
        setState(() {
          dataNotfound = true;
        });
      } else {
        setState(() {
          dataNotfound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          equipmentListData.addAll(equipmentListModel.data);
        } else {
          equipmentListData = equipmentListModel.data;
        }
        isDataLoaded = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getEquipmentList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getEquipmentList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getEquipmentList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          //title: "Site Evaluation",
          titles: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: CommonSearchTextfield(
                    hintText: 'Search',
                    textEditingController: searchQuery,
                    onChanged: (value) {
                      pageNo = 1;
                      getEquipmentList();
                    },
                  ),
                )
              : Text("Equipment List",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      )),
          searchEnabeled: true,
          image: !isSearchClicked
              ? SvgPicture.asset(
                  'assets/images/search.svg',
                )
              : SvgPicture.asset(
                  'assets/images/closeicon.svg',
                ),
          onSearchTap: () {
            setState(() {
              isSearchClicked = !isSearchClicked;
              searchQuery.text = '';
              if (isSearchClicked == false) getEquipmentList();
            });
          },
        ),
        backgroundColor: Color(Hardcoded.white),
        body: Column(
          children: [
            common_green_rotation_card(
              date: '${widget.rotation.startDate.day}',
              month:
                  "${Hardcoded.getMonthString(widget.rotation.startDate.month)}",
              text1: "${widget.rotation.rotationTitle}",
              text2: "${widget.rotation.hospitalTitle}",
              text3: "${widget.rotation.courseTitle}",
              Index: 0,
            ),
            Expanded(
              child: Visibility(
                visible:
                    isSearchClicked == false && isDataLoaded && pageNo == 1,
                child: common_loader(),
                replacement: Visibility(
                  visible: dataNotfound,
                  child: isSearchClicked
                      ? Padding(
                          padding: EdgeInsets.only(top: 40.0),
                          child: Center(
                            child: Container(
                              // width: double.infinity,
                              //height: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: globalHeight * 0.01,
                                      bottom: globalHeight * 0.1),
                                  child: NoDataFoundWidget(
                                    title: "No data found",
                                    imagePath: "assets/no_data_found.png",
                                  )),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 40.0),
                          child: Center(
                            child: Container(
                              // width: double.infinity,
                              //height: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: globalHeight * 0.01,
                                      bottom: globalHeight * 0.15),
                                  child: NoDataFoundWidget(
                                    title: "Equipment List not available",
                                    imagePath: "assets/no_data_found.png",
                                  )),
                            ),
                          ),
                        ),
                  replacement: RefreshIndicator(
                    onRefresh: () => pullToRefresh(),
                    color: Color(0xFFBBBBC6),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromARGB(24, 203, 204, 208),
                            blurRadius: 35.0, // soften the shadow
                            spreadRadius: 10.0, //extend the shadow
                            offset: Offset(
                              15.0,
                              15.0,
                            ),
                          )
                        ],
                      ),
                      child: Padding(
                      padding: const EdgeInsets.only(top:5.0,left:2,right: 2.0),
    child: CupertinoScrollbar(
    controller: _scrollController,
    child:ListView.builder(
                        shrinkWrap: true,
                        itemCount: equipmentListData.length,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CommonListContainerWidget(
                            mainTitle:
                                "Evaluation date : ${DateFormat("MMM dd, yyyy").format(equipmentListData[index].equipmentDate)}",
                            subTitle1: "Clinician Name : ",
                            title1:
                                equipmentListData[index].clinicianFullName,
                          );
                        },
                      ),
                    ),
                  ),
                  ),
                ),
            ),),),
          ],
        ),
      ),
    );
  }
}
