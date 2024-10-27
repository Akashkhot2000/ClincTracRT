import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProcedureCountScreen extends StatefulWidget {
  ProcedureCountScreen({
    Key? key,
    required this.allRotation,
  }) : super(key: key);
  final AllRotation allRotation;

  @override
  State<ProcedureCountScreen> createState() => _ProcedureCountScreenState();
}

class _ProcedureCountScreenState extends State<ProcedureCountScreen> {
  bool isSearchClicked = false;
  TextEditingController searchQuery = TextEditingController(text: '');
  String? selectedRotation;
  String? selectedRotationId;
  List<String> items = ['yoyo', 'test'];
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<ProcedureCountData> procedureCountData = [];
  bool isDataLoaded = true;

  void getProcedureCountList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      ProceduerCountRequest request = ProceduerCountRequest(
        accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        RotationId: widget.allRotation.rotationId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
      );
      final DataResponseModel dataResponseModel =
          await dataService.getProcedureCountList(request);
      ProcedureCountModel procedureCountModel =
          ProcedureCountModel.fromJson(dataResponseModel.data);
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
          procedureCountData.addAll(procedureCountModel.data);
        } else {
          procedureCountData = procedureCountModel.data;
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

      getProcedureCountList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getProcedureCountList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  List<Color> colorList = [
    Color(0xFFFEF6ED),
    Color(0xFFE9F4FF),
    Color(0xFFEFFDFA),
    Color(0xFFFEECF5),
    Color(0xFFF0F8FC),
    Color(0xFFEFEBFB),
  ];

  List<String> imagepath = [
    "assets/images/procedurecount/foundational.png",
    "assets/images/procedurecount/adultcare.png",
    "assets/images/procedurecount/diagno.png",
    "assets/images/procedurecount/criticalcare.png",
    "assets/images/procedurecount/neonatalcare.png",
    "assets/images/procedurecount/polysomo.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text(
          "${widget.allRotation.rotationTitle}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
        ),
      ),
      body:SingleChildScrollView(child:  Visibility(
        visible: isDataLoaded && pageNo == 1,
        child:Padding(
          padding: EdgeInsets.only(top: globalHeight * 0.3),
          child: common_loader(),),
        replacement: Visibility(
          visible: !datanotFound,
          replacement: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "No data found",
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView.builder(
                  itemCount: procedureCountData.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // switch (index) {
                        //   case 0:
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             ProcedureCountDetailScreen(
                        //               allRotation: widget.allRotation,
                        //                 procedureCountTopicId: procedureCountData.elementAt(index).pcId,
                        //               procedureCountTitle: procedureCountData.elementAt(index).title,
                        //             ),
                        //       ),
                        //     );
                            // break;
                        // }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Color(0xFFD3D3D3),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    // width: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE9F4FF),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Color(0xFFD3D3D3),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset(
                                          'assets/images/procedure_counts.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 10,
                                      ),
                                      child: Text(
                                        "${procedureCountData.elementAt(index).title}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),),
    );
  }
}
