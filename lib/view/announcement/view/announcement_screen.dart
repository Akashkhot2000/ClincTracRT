import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/announcement/model/announcement_model.dart';
import 'package:clinicaltrac/view/brief_case/models/brief_case_response.dart';
import 'package:clinicaltrac/view/brief_case/view/upload_document_bottom_sheet.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class AnnouncementScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;

  AnnouncementScreen({super.key, required this.userLoginResponse});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotFound = false;
  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<AnnouncementListData> announcementListData = [];

  dynamic progress = 0;

  int noOfDownloads = 0;

  final ReceivePort _receivePort = ReceivePort();
  bool isBackButtonActivated = true;

  void getAnnouncementList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest request = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text);
      final DataResponseModel dataResponseModel =
          await dataService.getAnnouncementList(request);
      AnnouncementListModel announcementListModel =
          AnnouncementListModel.fromJson(dataResponseModel.data);
      log("Total Record ---- ${announcementListModel.pager.totalRecords}");
      log("Data ---- ${dataResponseModel.data}");
      lastpage =
          (int.parse(announcementListModel.pager!.totalRecords!) / 10).ceil();
      if (announcementListModel.pager!.totalRecords == '0') {
        setState(() {
          dataNotFound = true;
        });
      } else {
        setState(() {
          dataNotFound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          announcementListData.addAll(announcementListModel.data);
        } else {
          announcementListData = announcementListModel.data;
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
      getAnnouncementList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getAnnouncementList();
    _scrollController.addListener(_scrollListener);
    super.initState();
    // _backgroundIsolate();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getAnnouncementList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();
  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: CommonAppBar(
        //   titles: isSearchClicked
        //       ? Padding(
        //     padding: const EdgeInsets.only(
        //       top: 5,
        //     ),
        //     child: Material(
        //       color: Colors.white,
        //       child: IOSKeyboardAction(
        //         label: 'DONE',
        //         focusNode: searchFocusNode,
        //         focusActionType: FocusActionType.done,
        //         onTap: () {},
        //         child: CommonSearchTextfield(
        //           focusNode: searchFocusNode,
        //           hintText: 'Search',
        //           textEditingController: searchQuery,
        //           onChanged: (value) {
        //             pageNo = 1;
        //             getAnnouncementList();
        //           },
        //         ),
        //       ),
        //     ),
        //   )
        //       : Text(
        //     "Announcement",
        //     textAlign: TextAlign.center,
        //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //       fontWeight: FontWeight.w600,
        //       fontSize: 22,
        //     ),
        //   ),
        //   searchEnabeled: true,
        //   image: !isSearchClicked
        //       ? SvgPicture.asset(
        //     'assets/images/search.svg',
        //   )
        //       : SvgPicture.asset(
        //     'assets/images/closeicon.svg',
        //   ),
        //   onSearchTap: () {
        //     setState(() {
        //       isSearchClicked = !isSearchClicked;
        //       searchQuery.text = '';
        //       FocusScope.of(context).unfocus();
        //       if (isSearchClicked == false) getAnnouncementList();
        //     });
        //   },
        // ),
        backgroundColor: Color(Hardcoded.white),
        body: Visibility(
          visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: globalHeight * 0.06,
            ),
            child: common_loader(),
          ),
          replacement: Visibility(
            visible: !dataNotFound,
            replacement: isSearchClicked
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: globalHeight * 0.06,
                        ),
                        child: NoDataFoundWidget(
                          title: "No data found",
                          imagePath: "assets/no_data_found.png",
                        )),
                  )
                : Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: globalHeight * 0.06,
                        ),
                        child: NoDataFoundWidget(
                          title: "Announcements not available",
                          imagePath: "assets/no_data_found.png",
                        )),
                  ),
            child: RefreshIndicator(
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
                  padding: const EdgeInsets.only(top: 2.0, left: 2, right: 2.0),
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: announcementListData.length,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: announcementListData[
                                                              index]
                                                          .announcementDescription
                                                          .length <=
                                                      150
                                                  ? globalHeight * 0.3
                                                  : globalHeight * 0.55,
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    left: 10,
                                                                    right: 0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "${toBeginningOfSentenceCase(announcementListData[index].announcementTitle)}",
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          21,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    right: 10),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Icon(
                                                                Icons.clear,
                                                                color: Color(
                                                                    0xFF000000),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 2.0,
                                                          bottom: 5,
                                                          top: 6),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "To Date : ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF868998),
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                              "${DateFormat("MMM dd, yyyy").format(announcementListData[index].toDate!)}",
                                                              // "${DateFormat("MMM dd, yyyy").format(announcementListData[index].toDate!)}; ${DateFormat("hh:mm aa").format(announcementListData[index].toDate!)}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12,
                                                              ),
                                                              maxLines: 2),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      // scrollDirection: Axis.vertical,
                                                      child: ListView(
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 13,
                                                                      right: 5),
                                                              child: Text(
                                                                "${toBeginningOfSentenceCase(announcementListData[index].announcementDescription)}",
                                                                // maxLines: 4,
                                                                // overflow:
                                                                //     TextOverflow.ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        color: Colors.white12,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, top: 5, bottom: 2),
                                              child: Container(
                                                height: 0.077.sh,
                                                width: 0.12.sw,
                                                padding: REdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: initialColor
                                                      .elementAt(index %
                                                          initialColor.length)
                                                      .withOpacity(0.2),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "${DateFormat("dd").format(announcementListData[index].fromDate!)}",
                                                      // '14',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 19.sp,
                                                            color: initialColor
                                                                .elementAt(index %
                                                                    initialColor
                                                                        .length),
                                                          ),
                                                    ),
                                                    // const SizedBox(
                                                    //   height: 10,
                                                    // ),
                                                    Text(
                                                      "${DateFormat("MMM").format(announcementListData[index].toDate!)}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 11.sp,
                                                            color: initialColor
                                                                .elementAt(index %
                                                                    initialColor
                                                                        .length),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: globalWidth / 1.4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    left: 8,
                                                    right: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Text(
                                                        "${toBeginningOfSentenceCase(announcementListData[index].announcementTitle!)}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFF000000),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 15,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    // Expanded(child:
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4.0,
                                                          top: 2,
                                                          right: 5),
                                                      child: Text(
                                                        "${toBeginningOfSentenceCase(announcementListData[index].announcementDescription!)}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFF000000),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                                "assets/images/right_arrow.svg"),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xFFE8E8E8),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
