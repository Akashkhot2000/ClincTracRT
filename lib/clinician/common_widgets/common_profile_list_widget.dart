import 'package:clinicaltrac/clinician/common_widgets/common_image_zoom_widget.dart';
import 'package:clinicaltrac/common/common_null_check_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/view/check_offs/view/add_checkoffs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CommonProfileListWidget extends StatefulWidget {
  CommonProfileListWidget(
      {Key? key,
        this.date,
        this.date1,
        this.date2,
        this.statusString,
        this.statusColor,
        this.monthTitle,
        this.monthTitle1,
        this.monthTitle2,
        this.month,
        this.mainTitle,
        this.icon7,
        this.icon8,
        this.title1,
        this.title2,
        this.title3,
        this.title4,
        this.title5,
        this.title6,
        this.title7,
        this.title8,
        this.title9,
        this.title10,
        this.title11,
        this.title12,
        this.title13,
        this.title14,
        this.title15,
        this.title16,
        this.title17,
        this.title18,
        this.title19,
        this.title20,
        this.title21,
        this.title22,
        this.title23,
        this.title24,
        this.title25,
        this.title26,
        this.title27,
        this.title28,
        this.title29,
        this.subTitle1,
        this.subTitle2,
        this.subTitle3,
        this.subTitle4,
        this.subTitle5,
        this.subTitle6,
        this.subTitle7,
        this.subTitle8,
        this.subTitle9,
        this.subTitle10,
        this.subTitle11,
        this.subTitle12,
        this.subTitle13,
        this.subTitle14,
        this.subTitle15,
        this.subTitle16,
        this.subTitle17,
        this.subTitle18,
        this.subTitle19,
        this.subTitle20,
        this.subTitle21,
        this.subTitle22,
        this.subTitle23,
        this.subTitle24,
        this.subTitle25,
        this.subTitle26,
        this.subTitle27,
        this.subTitle28,
        this.subTitle29,
        this.navigateText,
        this.navigateText1,
        this.navigateText2,
        this.buttonTitle,
        this.buttonTitle1,
        this.buttonTitle2,
        this.navigateButton,
        this.navigateButton1,
        this.navigateButton2,
        this.status,
        this.score,
        this.name,
        this.Index,
        this.isDownRow,
        this.ClinicianResponseAgree = false,
        this.SchoolResponseAgree = false,
        this.isDraggable,
        this.isDelete,
        this.isIncident = false,
        this.height = 120,
        this.JournalId,
        this.btnSvgImage,
        this.btnSvgImage1,
        this.btnSvgImage2,
        this.icon,
        this.verticalDivider,
        this.divider,
        this.networkImage,
      })
      : super(key: key);
  String? date;
  String? date1;
  String? date2;
  String? statusString;
  Color? statusColor;
  String? monthTitle;
  String? monthTitle1;
  String? monthTitle2;
  String? month;
  String? mainTitle;
  String? icon7;
  String? icon8;
  String? title1;
  String? title2;
  String? title3;
  String? title4;
  String? title5;
  String? title6;
  String? title7;
  String? title8;
  String? title9;
  String? title10;
  String? title11;
  String? title12;
  String? title13;
  String? title14;
  String? title15;
  String? title16;
  String? title17;
  String? title18;
  String? title19;
  String? title20;
  String? title21;
  String? title22;
  String? title23;
  String? title24;
  String? title25;
  String? title26;
  String? title27;
  String? title28;
  String? title29;
  String? subTitle1;
  String? subTitle2;
  String? subTitle3;
  String? subTitle4;
  String? subTitle5;
  String? subTitle6;
  String? subTitle7;
  String? subTitle8;
  String? subTitle9;
  String? subTitle10;
  String? subTitle11;
  String? subTitle12;
  String? subTitle13;
  String? subTitle14;
  String? subTitle15;
  String? subTitle16;
  String? subTitle17;
  String? subTitle18;
  String? subTitle19;
  String? subTitle20;
  String? subTitle21;
  String? subTitle22;
  String? subTitle23;
  String? subTitle24;
  String? subTitle25;
  String? subTitle26;
  String? subTitle27;
  String? subTitle28;
  String? subTitle29;
  void Function()? navigateText;
  void Function()? navigateText1;
  void Function()? navigateText2;
  String? buttonTitle;
  String? buttonTitle1;
  String? buttonTitle2;
  void Function()? navigateButton;
  void Function()? navigateButton1;
  void Function()? navigateButton2;
  String? status;
  String? score;
  String? name;
  bool? ClinicianResponseAgree;
  bool? SchoolResponseAgree;
  bool? isDraggable;
  bool? isDownRow;
  bool? isDelete;
  bool? isIncident;
  int? Index;
  String? JournalId;
  double? height;
  String? btnSvgImage;
  String? btnSvgImage1;
  String? btnSvgImage2;
  Icon? icon;
  VerticalDivider? verticalDivider;
  Divider? divider;
  String? networkImage;

  @override
  State<CommonProfileListWidget> createState() =>
      _CommonProfileListWidgetState();
}

class _CommonProfileListWidgetState extends State<CommonProfileListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9, top: 9, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xFFF1F1F1),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:10,left:7,right:7,bottom:5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        widget.networkImage != null
                            ? Padding(
                          padding: EdgeInsets.only(top: 5, right: 3),
                          child:
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageZoomScreen(
                                        imagename: widget.networkImage
                                            .toString()
                                            .split("/")
                                            .last,
                                        image: widget.networkImage
                                            .toString(),
                                        // spannerImageBoardList: widget.spannerImageBoardList,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width: globalWidth * 0.14.w,
                              height: globalHeight * 0.057.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(55),
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.green,
                                ),
                                // color: Color(0xFFEAFBE2),
                                image:  DecorationImage(
                                    image: FadeInImage(
                                      placeholder: AssetImage("assets/default-user.png"),
                                      fit: BoxFit.contain,
                                      image:NetworkImage("${widget.networkImage}",),
                                    ).image,
                                    fit: BoxFit.contain
                                )
                              ),
                              // child:Padding(
                              //   padding:
                              //   const EdgeInsets
                              //       .only(
                              //     top: 1.0,
                              //     bottom: 1.0,
                              //     left: 1.0,
                              //     right: 1.0,
                              //   ),
                              //   child: ClipRRect(
                              //     borderRadius:
                              //     BorderRadius
                              //         .circular(
                              //       50.0,
                              //     ),
                              //     child: FadeInImage
                              //         .assetNetwork(
                              //       placeholder:
                              //       'assets/default-user.png',
                              //       image: "${widget.networkImage}",
                              //       fit: BoxFit.contain,
                              //       height: 95,
                              //       width: 90,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        )
                            : Container(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  NullCheckWidget(
                                    child: SizedBox(
                                      width: widget.statusString!.length == 9
                                          ? globalWidth * 0.50
                                          : widget.statusString!.length == 8
                                          ? globalWidth * 0.525
                                          : globalWidth * 0.52,
                                      child: Text(
                                        "${widget.mainTitle}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    varia: widget.mainTitle,
                                  ),
                                  widget.statusString == null
                                      ? Container()
                                      : Padding(
                                        padding: EdgeInsets.only(left: widget.statusString!.length < 7 ? 22.0:0),
                                        child: Container(
                                    decoration: BoxDecoration(
                                          color: widget.statusString ==
                                              "Pending"
                                              ? Color(0x40868998)
                                              : widget.statusString ==
                                              "Completed"
                                              ? Color(0x2B83B6FB)
                                              : Color(0x40868998),
                                              // : Color(0xFF1FBC2F),
                                          //Color(0x2B83B6FB),
                                          borderRadius:
                                          BorderRadius.circular(6)),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 3,
                                            left: 5,
                                            right: 5,
                                            bottom: 3),
                                        child: NullCheckWidget(
                                          child: Text(
                                            "${widget.statusString}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: widget
                                                    .statusString ==
                                                    "Pending"
                                                    ? Colors.black
                                                    : widget.statusString ==
                                                    "Completed"
                                                    ? Color(
                                                    0xFF519CFF)
                                                    : Colors.black),
                                                    // : Colors.white),
                                          ),
                                          varia: widget.statusString,
                                        ),
                                    ),
                                  ),
                                      ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.date1 != null ||
                                    widget.monthTitle1 != null
                                    ? Padding(
                                  padding:
                                  EdgeInsets.only(top: 5, left: 10),
                                  child: Container(
                                    width: globalWidth * 0.13,
                                    height: globalHeight * 0.075,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Color(0xFFEAFBE2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${widget.date1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                            color: Color(Hardcoded
                                                .primaryGreen),
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "${widget.monthTitle1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                            color: Color(Hardcoded
                                                .primaryGreen),
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : Container(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.subTitle1 == "" ||
                                        widget.title1 == ""
                                        ? Container()
                                        : Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          NullCheckWidget(
                                            child: Text(
                                              "${widget.subTitle1}",
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color: Color(
                                                      0xFF868998)),
                                            ),
                                            varia: widget.subTitle1,
                                          ),
                                          NullCheckWidget(
                                            child: SizedBox(
                                              width: globalWidth * 0.6,
                                              child: Text(
                                                "${widget.title1}",
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            varia: widget.title1,
                                          ),
                                        ]),
                                    widget.subTitle2 == "" ||
                                        widget.title2 == ""
                                        ? Container()
                                        : Row(children: [
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.subTitle2}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color:
                                              Color(0xFF868998)),
                                        ),
                                        varia: widget.subTitle2,
                                      ),
                                      NullCheckWidget(
                                        child: SizedBox(
                                          width: globalWidth * 0.1,
                                          child: Text(
                                            "${widget.title2}",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        varia: widget.title2,
                                      ),
                                    ]),
                                    widget.subTitle3 == "" ||
                                        widget.title3 == ""
                                        ? Container()
                                        : Row(children: [
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.subTitle3}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color:
                                              Color(0xFF868998)),
                                        ),
                                        varia: widget.subTitle3,
                                      ),
                                      NullCheckWidget(
                                        child: SizedBox(
                                          width: globalWidth * 0.59,
                                          child: Text(
                                            "${widget.title3}",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        varia: widget.title3,
                                      ),
                                    ]),
                                    widget.subTitle20 == "" ||
                                        widget.title20 == ""
                                        ? Container()
                                        : Row(children: [
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.subTitle20}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color:
                                              Color(0xFF868998)),
                                        ),
                                        varia: widget.subTitle20,
                                      ),
                                      NullCheckWidget(
                                        child: SizedBox(
                                          width: globalWidth * 0.4,
                                          child: Text(
                                            "${widget.title20}",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              // color: widget.title20 == "Pass"
                                              //     ? Color(0xFF1FBC2F)
                                              // :widget.title20 == "Fail"
                                              //     ?Color(0xFFFF746A)
                                              //     : Colors.black,
                                            ),
                                          ),
                                        ),
                                        varia: widget.title20,
                                      ),
                                    ]),
                                    widget.subTitle21 == "" ||
                                        widget.title21 == ""
                                        ? Container()
                                        : Row(children: [
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.subTitle21}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color:
                                              Color(0xFF868998)),
                                        ),
                                        varia: widget.subTitle21,
                                      ),
                                      NullCheckWidget(
                                        child: SizedBox(
                                          width: globalWidth * 0.53,
                                          child: Text(
                                            "${widget.title21}",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: widget.title21 == "Pass"
                                                  ? Color(0xFF1FBC2F)
                                                  :widget.title21 == "Fail"
                                                  ?Color(0xFFFF746A)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        varia: widget.title21,
                                      ),
                                    ]),
                                  ],
                                ),
                                widget.score != null
                                    ? Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Container(
                                    width: globalWidth * 0.13,
                                    height: globalHeight * 0.075,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Color(0xFFF1F5F5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Score",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                            color: Color(
                                                Hardcoded.black),
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          widget.score!.length > 3
                                              ?
                                          // widget.score!.length >2 ? widget.score!.replaceAll(RegExp('\\.'), ''):
                                          widget.score!
                                              .substring(0, 4)
                                              : widget.score!.substring(0,
                                              widget.score!.length),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                            color: Color(
                                                Hardcoded.black),
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ]),
                      widget.subTitle4 == "" || widget.title4 == ""
                          ? Container()
                          : Row(children: [
                        NullCheckWidget(
                          child: Text(
                            "${widget.subTitle4}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF868998)),
                          ),
                          varia: widget.subTitle4,
                        ),
                        NullCheckWidget(
                          child: SizedBox(
                            width: globalWidth * 0.5,
                            child: Text(
                              "${widget.title4}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          varia: widget.title4,
                        ),
                      ]),
                      widget.subTitle5 == "" || widget.title5 == ""
                          ? Container()
                          : Row(children: [
                        NullCheckWidget(
                          child: Text(
                            "${widget.subTitle5}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF868998)),
                          ),
                          varia: widget.subTitle5,
                        ),
                        NullCheckWidget(
                          child: SizedBox(
                            width: globalWidth * 0.5,
                            child: Text(
                              "${widget.title5}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          varia: widget.title5,
                        ),
                      ]),
                      widget.subTitle6 == "" || widget.title6 == ""
                          ? Container()
                          : Row(children: [
                        NullCheckWidget(
                          child: Text(
                            "${widget.subTitle6}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF868998)),
                          ),
                          varia: widget.subTitle6,
                        ),
                        NullCheckWidget(
                          child: SizedBox(
                            width: globalWidth * 0.3,
                            child: Text(
                              "${widget.title6}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          varia: widget.title6,
                        ),
                      ]),
                      widget.subTitle19 == "" || widget.title19 == ""
                          ? Container()
                          : Row(children: [
                        NullCheckWidget(
                          child: Text(
                            "${widget.subTitle19}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF868998)),
                          ),
                          varia: widget.subTitle19,
                        ),
                        NullCheckWidget(
                          child: SizedBox(
                            width: globalWidth * 0.6,
                            child: Text(
                              "${widget.title19}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          varia: widget.title19,
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.subTitle26 == "" || widget.title26 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle26}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle26,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title26}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                  widget.title26 == "Under Review"
                                      ? Color(0xFFFF746A)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title26,
                            ),
                          ]),
                          widget.subTitle27 == "" || widget.title27 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle27}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle27,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title27}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              varia: widget.title27,
                            ),
                          ]),
                        ],
                      ),
                      widget.divider != null
                          ? Padding(
                          padding: EdgeInsets.only(
                            top: globalWidth * 0.01,
                            bottom: globalWidth * 0.01,
                          ),
                          child: widget.divider)
                          : Container(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.subTitle28 == "" || widget.title28 == ""
                              ? Container()
                              : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title28}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title28,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle28}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle28,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle29}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle29,
                                ),
                              ]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.subTitle7 == "" || widget.title7 == ""
                                  ? Container()
                                  : Row(children: [
                                widget.icon7 == null
                                    ? Container()
                                    : Padding(
                                  padding:
                                  EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(
                                      "${widget.icon7}"),
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle7}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle7,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title7}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title7,
                                ),
                              ]),
                              widget.subTitle8 == "" || widget.title8 == ""
                                  ? Container()
                                  : Row(children: [
                                widget.icon8 == null
                                    ? Container()
                                    : Padding(
                                  padding:
                                  EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(
                                      "${widget.icon8}"),
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle8}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle8,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title8}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title8,
                                ),
                              ]),
                              widget.subTitle9 == "" || widget.title9 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle9}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle9,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title9}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title9,
                                ),
                              ]),
                              widget.subTitle10 == "" || widget.title10 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle10}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle10,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title10}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title10,
                                ),
                              ]),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.subTitle12 == "" || widget.title12 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle12}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle12,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title12}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title12,
                                ),
                              ]),
                              widget.subTitle13 == "" || widget.title13 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle13}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle13,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title13}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title13,
                                ),
                              ]),
                              widget.subTitle14 == "" || widget.title14 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle14}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle14,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title14}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title14,
                                ),
                              ]),
                              widget.subTitle15 == "" || widget.title15 == ""
                                  ? Container()
                                  : Row(children: [
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.subTitle15}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF868998)),
                                  ),
                                  varia: widget.subTitle15,
                                ),
                                NullCheckWidget(
                                  child: Text(
                                    "${widget.title15}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  varia: widget.title15,
                                ),
                              ]),
                            ],
                          ),
                          // widget.score != null
                          //     ? Padding(
                          //         padding: EdgeInsets.only(top: 5),
                          //         child: Container(
                          //           width: globalWidth * 0.13,
                          //           height: globalHeight * 0.075,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(10),
                          //             color: Color(0xFFEAFBE2),
                          //           ),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: [
                          //               Text(
                          //                 "Score",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .titleLarge!
                          //                     .copyWith(
                          //                       color: Color(
                          //                           Hardcoded.primaryGreen),
                          //                       fontWeight: FontWeight.w500,
                          //                       fontSize: 12,
                          //                     ),
                          //               ),
                          //               Text(
                          //                 widget.score!.length > 3
                          //                     ?
                          //                     // widget.score!.length >2 ? widget.score!.replaceAll(RegExp('\\.'), ''):
                          //                     widget.score!.substring(0, 4)
                          //                     : widget.score!.substring(
                          //                         0, widget.score!.length),
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .titleLarge!
                          //                     .copyWith(
                          //                       color: Color(
                          //                           Hardcoded.primaryGreen),
                          //                       fontWeight: FontWeight.w600,
                          //                       fontSize: 18,
                          //                     ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       )
                          //     : Container(),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.subTitle17 == "" || widget.title17 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle17}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle17,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title17}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: widget.title17 == "Yes"
                                      ? Color(0xFF1FBC2F)
                                      : widget.title17 == "No"
                                      ? Color(0xFFFF746A)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title17,
                            ),
                          ]),
                          widget.subTitle18 == "" || widget.title18 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle18}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle18,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title18}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: widget.title18 == "Yes"
                                      ? Color(0xFF1FBC2F)
                                      : widget.title18 == "No"
                                      ? Color(0xFFFF746A)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title18,
                            ),
                          ]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.subTitle22 == "" || widget.title22 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle22}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle22,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title22}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: widget.title22 == "Yes"
                                      ? Color(0xFF1FBC2F)
                                      : widget.title22 == "No"
                                      ? Color(0xFFFF746A)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title22,
                            ),
                          ]),
                          widget.subTitle23 == "" || widget.title23 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle23}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle23,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title23}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: widget.title23 == "Yes"
                                      ? Color(0xFF1FBC2F)
                                      : widget.title23 == "No"
                                      ? Color(0xFFFF746A)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title23,
                            ),
                          ]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.subTitle24 == "" || widget.title24 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle24}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle24,
                            ),
                            NullCheckWidget(
                              child: GestureDetector(
                                onTap: widget.title24 == "-"
                                    ? null
                                    : widget.navigateText,
                                child: Container(
                                  height: globalHeight * 0.025,
                                  width: globalWidth * 0.15,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      "${widget.title24}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                        widget.title24 == "View"
                                            ? Color(0xFF1FBC2F)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              varia: widget.title24,
                            ),
                          ]),
                          widget.subTitle25 == "" || widget.title25 == ""
                              ? Container()
                              : Row(children: [
                            NullCheckWidget(
                              child: Text(
                                "${widget.subTitle25}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              varia: widget.subTitle25,
                            ),
                            NullCheckWidget(
                              child: Text(
                                "${widget.title25}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: widget.title25 == "Yes"
                                      ? Color(0xFF1FBC2F)
                                      : Colors.black,
                                ),
                              ),
                              varia: widget.title24,
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.buttonTitle != null ||
                    widget.buttonTitle1 != null ||
                    widget.buttonTitle2 != null
                    ? Container(
                  height: globalHeight * 0.055,
                  decoration: BoxDecoration(
                    color: const Color(0x1413AD5D),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: widget.buttonTitle != null
                          ? GestureDetector(
                        onTap: widget.navigateButton,
                        child: Container(
                          // width: globalWidth * 1,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: globalWidth * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  widget.btnSvgImage != null ?  Padding(
                                    padding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    child: SvgPicture.asset(
                                        "${widget.btnSvgImage}"),
                                  ):SizedBox(),
                                  NullCheckWidget(
                                    child: Text(
                                      "${widget.buttonTitle}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color:
                                        widget.buttonTitle ==
                                            "Delete"
                                            ? Color(
                                            0xFFFA0202)
                                            : Color(
                                            0xFF01A750),
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                    varia: widget.buttonTitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: widget.navigateButton1,
                            child: Container(
                              width: globalWidth * 0.4,
                              color: Colors.transparent,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: globalWidth * 0.01,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      widget.btnSvgImage1 != null ? Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                            globalWidth * 0.02,
                                            bottom: globalHeight *
                                                0.002),
                                        child: SvgPicture.asset(
                                            "${widget.btnSvgImage1}"),
                                      ): SizedBox(),
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.buttonTitle1}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: widget
                                                .buttonTitle1 ==
                                                "Delete"
                                                ? Color(
                                                0xFFFA0202)
                                                : Color(
                                                0xFF01A750),
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                        varia: widget.buttonTitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                // left: globalWidth * 0.05,
                                right: globalWidth * 0.0018,
                              ),
                              child: widget.verticalDivider),
                          GestureDetector(
                            onTap: widget.navigateButton2,
                            child: Container(
                              width: globalWidth * 0.36,
                              color: Colors.transparent,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: widget.status == 0
                                        ? globalWidth * 0.05
                                        : widget.status == 1
                                        ? globalWidth * 0.07
                                        : globalWidth * 0.001,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: globalWidth * 0.01,
                                        ),
                                        child: SvgPicture.asset(
                                            "${widget.btnSvgImage2}"),
                                      ),
                                      NullCheckWidget(
                                        child: Text(
                                          "${widget.buttonTitle2}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: widget
                                                .buttonTitle2 ==
                                                "Delete"
                                                ? Color(
                                                0xFFFA0202)
                                                : Color(
                                                0xFF01A750),
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                        varia: widget.buttonTitle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
