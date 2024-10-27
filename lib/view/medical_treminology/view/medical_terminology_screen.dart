// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, avoid_unnecessary_containers

import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/medical_treminology/model/medical_terminology_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class MedicalTerminologyScreen extends StatefulWidget {
  MedicalTerminologyScreen(
      {required this.userLoginResponse, required this.medicalTerminologyModel});

  final MedicalTerminologyModel medicalTerminologyModel;
  UserLoginResponse userLoginResponse;

  @override
  State<MedicalTerminologyScreen> createState() =>
      _MedicalTerminologyScreenState();
}

class _MedicalTerminologyScreenState extends State<MedicalTerminologyScreen> {
  FlutterTts? flutterTts;
  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController(text: '');
  bool isSearchClicked = false;
  late bool isSpeak = false;

  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<MedicalTerminology> medicalTerminologyList = [];
  bool isDataLoaded = true;
  int index1 = -1;

  void getMedicalTerminologyData() async {
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
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getMedicalTerminologyList(request);
      MedicalTerminologyModel medicalTerminologyModel =
          MedicalTerminologyModel.fromJson(dataResponseModel.data);
      lastpage =
          (int.parse(medicalTerminologyModel.pager.totalRecords!) / 10).ceil();
      if (medicalTerminologyModel.pager.totalRecords == '0') {
        setState(() {
          datanotFound = true;
        });
      } else {
        setState(() {
          datanotFound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          medicalTerminologyList.addAll(medicalTerminologyModel.data);
        } else {
          medicalTerminologyList = medicalTerminologyModel.data;
        }
        isDataLoaded = false;
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;

      getMedicalTerminologyData();
    }
  }

  @override
  void initState() {
    getMedicalTerminologyData();
    _scrollController.addListener(_scrollListener);
    super.initState();
    flutterTts = FlutterTts();
    flutterTts!.setCompletionHandler(() {
      setState(() {
        isSpeak = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    flutterTts!.stop();
    super.dispose();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getMedicalTerminologyData();
    searchTextController.text = '';
    isSearchClicked = false;
  }

  Future<void> _speak(String title, int index) async {
    if (index1 == index) {
      _stop(title);
      setState(() {
        index1 = index;
      });
    } else {
      // String text = textController.text;
      await flutterTts!.setLanguage('en-US');
      await flutterTts!.setPitch(1.0);
      await flutterTts!.setSpeechRate(0.50);
      await flutterTts!.speak(title);
      // await flutterTts!.stop();
    }
  }

  Future<void> _stop(
    String title,
  ) async {
    // if(flutterTts != null){
    await flutterTts!.stop();
    // }
  }

  List<String> titleList = [
    'What is Lorem Ipsum',
    'What is Lorem Ipsum',
    'What is Lorem Ipsum',
    "What is Lorem Ipsum",
    "What is Lorem Ipsum"
  ];
  List<String> textList = [
    'Hi',
    'Hello',
    'How are you',
    "Polysomonographic",
    "hello"
  ];
  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return NoInternet(
      child: Scaffold(
        appBar: CommonAppBar(
          titles: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: searchFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonSearchTextfield(
                        focusNode: searchFocusNode,
                        hintText: 'Search',
                        textEditingController: searchTextController,
                        onChanged: (value) {
                          pageNo = 1;
                          getMedicalTerminologyData();
                        },
                      ),
                    ),
                  ),
                )
              : Text("Medical Terminology",
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
            setState(
              () {
                isSearchClicked = !isSearchClicked;
                searchTextController.text = '';
                FocusScope.of(context).unfocus();
                if (isSearchClicked == false) getMedicalTerminologyData();
              },
            );
          },
        ),
        body:
            // SingleChildScrollView(child:
            //   Scrollable(
            // viewportBuilder: (BuildContext context, ViewportOffset position) =>
            //     Slidable(
            //   enabled: true,
            //   child:
            Padding(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 5,
          ),
          child: Visibility(
            visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
            child: Padding(
              padding: EdgeInsets.only(top: globalHeight * 0.03),
              child: common_loader(),
            ),
            replacement: Visibility(
              visible: !datanotFound,
              replacement: Padding(
                padding: EdgeInsets.only(top: globalHeight * 0.01),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                    child: NoDataFoundWidget(
                      title: "No data found",
                      imagePath: "assets/no_data_found.png",
                    ),
                  ),
                ),
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
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child:CupertinoScrollbar(
                    controller: _scrollController,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: medicalTerminologyList.length,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          log("Scroll.....${_scrollController}");
                          final texts = medicalTerminologyList[index].description;
                          final title = medicalTerminologyList[index].title;
                          final both =
                              '${title}.     ${texts}.'; // title + texts;
                          return GestureDetector(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 12, right: 5),
                              child: Container(
                                // height: 50,
                                color: Colors.white12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${title}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: isSpeak
                                              ? index1 == index
                                                  ? SvgPicture.asset(
                                                      "assets/images/playIcon.svg")
                                                  : SvgPicture.asset(
                                                      "assets/images/pauseIcon.svg")
                                              : SvgPicture.asset(
                                                  "assets/images/pauseIcon.svg"),
                                          // child: index1 == index ? SvgPicture.asset("assets/images/playIcon.svg"):SvgPicture.asset("assets/images/pauseIcon.svg"),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 1, bottom: 10),
                                      child: Text(
                                        "${texts}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                              fontSize: 13,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0, right: 8),
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              isSearchClicked = false;
                              // isPlay = !isPlay;
                              setState(() {
                                isSpeak = true;
                                // index1 = -1;
                                if (index1 == index) {
                                  _speak(both, index);
                                  setState(() {
                                    index1 = index == index1 ? -1 : index;
                                  });
                                } else {
                                  _stop(title);
                                  _speak(both, index);
                                  setState(() {
                                    index1 = index == index1 ? -1 : index;
                                  });
                                }
                              });
                            },
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
      ),
      //   ),
      // ),
    );
  }
}
