import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_steps_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_steps_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class ProcedureCountStepsScreen extends StatefulWidget {
  const ProcedureCountStepsScreen(
      {Key? key,
      required this.procedureCountsCode,
      required this.procedureCountTopicId,
      required this.procedureCountName})
      : super(key: key);
  final procedureCountsCode;
  final procedureCountTopicId;
  final procedureCountName;

  @override
  State<ProcedureCountStepsScreen> createState() =>
      _ProcedureCountStepsScreenState();
}

class _ProcedureCountStepsScreenState extends State<ProcedureCountStepsScreen> {
  bool isSearchClicked = false;
  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController(text: '');
  String? selectedRotation;
  String? selectedRotationId;
  List<String> items = ['yoyo', 'test'];
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<ProcedureCountStepsData> procedureCountStepsData = [];
  bool isDataLoaded = true;

  void getProcedureCountStepsList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      ProceduerCountStepsRequest request = ProceduerCountStepsRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        procedureCountsCode: widget.procedureCountsCode,
        procedureCountTopicId: widget.procedureCountTopicId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getProcedureCountStepsList(request);
      ProcedureCountStepsModel procedureCountModel =
          ProcedureCountStepsModel.fromJson(dataResponseModel.data);
      lastpage =
          (int.parse(procedureCountModel.pager.totalRecords!) / 5).ceil();
      if (procedureCountModel.pager.totalRecords == '0') {
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
          procedureCountStepsData.addAll(procedureCountModel.data);
        } else {
          procedureCountStepsData = procedureCountModel.data;
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

      getProcedureCountStepsList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getProcedureCountStepsList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    searchTextController.text = '';
    getProcedureCountStepsList();
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        getProcedureCountStepsList();
                      },
                    ),
                  ),
                ),
              )
            : Text("${widget.procedureCountName}",
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
              if (isSearchClicked == false) getProcedureCountStepsList();
            },
          );
        },
      ),
      body: Scrollable(
        viewportBuilder: (BuildContext context, ViewportOffset position) =>
            Slidable(
          enabled: true,
          child: Visibility(
            visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
            child: common_loader(),
            replacement: Visibility(
              visible: !datanotFound,
              replacement: isSearchClicked
                  ? Padding(
                      padding: EdgeInsets.only(top: 0.0),
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
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                          child: NoDataFoundWidget(
                            title: "Procedure Count Steps not available",
                            imagePath: "assets/no_data_found.png",
                          ),
                        ),
                      ),
                    ),
              child: RefreshIndicator(
                onRefresh: () => pullToRefresh(),
                color: Color(0xFFBBBBC6),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 2, bottom: 5),
                  child:CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      itemCount: procedureCountStepsData.length,
                      shrinkWrap: true,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                            left: 10,
                            right: 6,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 3),
                                child: Text(
                                  "${procedureCountStepsData[index].title}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        // color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 8),
                                child: Text(
                                  "ID : ${procedureCountStepsData[index].sortOrder}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: 14,
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
