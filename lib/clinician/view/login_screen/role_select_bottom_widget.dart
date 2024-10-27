// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, override_on_non_overriding_member, must_call_super

import 'dart:async';
import 'dart:developer';

import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleSelectBottomWidget extends StatefulWidget {
  const RoleSelectBottomWidget({Key? key}) : super(key: key);

  @override
  State<RoleSelectBottomWidget> createState() => _RoleSelectBottomWidgetState();
}

class _RoleSelectBottomWidgetState extends State<RoleSelectBottomWidget> {
  ScrollController scrollController = ScrollController();

  List<String> images = [
    "assets/images/student.png",
    "assets/images/clinician_img.png",
  ];
  List<String> title = [
    "Student",
    "Clinician",
  ];
  List<String> subtitle = [
    "Are you a Student?",
    "Are you a Clinician?",
  ];

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double itemHeight = height / 14;
    final double itemWidth = width / 1;

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          SizedBox(height: 0.43.sh
              // height: globalHeight * 0.52,
              ),
          // Header(),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(Hardcoded.white),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 0),
                          child: Text(
                            'Select Your Role',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: title.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 0.02.sh,
                                ),
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 0.02.sh,
                                          bottom: 0.02.sh,
                                          left: 0.05.sh,
                                          right: 0.05.sh,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (title[index] == "Clinician") {
                                              AppConsts.userType = "1";
                                              Navigator.pushNamed(
                                                context,
                                                Routes.userLogin,
                                              );
                                            } else if (title[index] ==
                                                "Student") {
                                              AppConsts.userType = "0";
                                              Navigator.pushNamed(
                                                context,
                                                Routes.userLogin,
                                              );
                                            }
                                            log("${AppConsts.userType}");
                                          },
                                          child: Container(
                                            height: 0.1.sh,
                                            decoration: BoxDecoration(
                                              color:
                                                  Color(Hardcoded.primaryGreen),
                                              // color: Color(Hardcoded.primaryGreen).withOpacity(0.4),
                                              // border: Border.all(color: Color(Hardcoded.primaryGreen)),
                                              borderRadius: BorderRadius.circular(20
                                                // bottomRight: Radius.circular(20.0),
                                                // topLeft: Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0.sw,
                                                        top: 0.035.sh),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 1.0),
                                                      child: Text(
                                                        "Login As ${title[index]}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 15,
                                                              color: Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 0.03.sh,
                                          bottom: 0.02.sh,
                                          left: 0.0.sh,
                                          right: 0.3.sh,
                                        ),
                                        child: Container(
                                          height: 100.sp,
                                          decoration: BoxDecoration(
                                            // color: Colors.greenAccent,
                                            // border: Border.all(color: Color(Hardcoded.primaryGreen)),
                                            borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Image.asset(
                                            images[index],
                                          ),
                                          // child: SvgPicture.asset( images[index],),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 0.055.sh,
                                          bottom: 0.0.sh,
                                          left: 0.31.sh,
                                          right: 0.0.sh,
                                        ),
                                        // child: Container(
                                        //   height: 0.08.sh,
                                        //   width: 0.1.sw,
                                        //   decoration: BoxDecoration(
                                        //       color: Color(Hardcoded.white),
                                        //       // color: Color(Hardcoded.primaryGreen),
                                        //       border: Border.all(
                                        //           color: Color(
                                        //               Hardcoded.primaryGreen)),
                                        //       borderRadius:
                                        //           BorderRadius.circular(30)
                                        //       // borderRadius: BorderRadius.only(
                                        //       //   bottomRight: Radius.circular(20.0),
                                        //       //   topLeft: Radius.circular(20.0),
                                        //       // ),
                                        //       ),
                                          child:      Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
                                          // child: Padding(
                                          //   padding: EdgeInsets.all(0.01.sh),
                                          //   child: SvgPicture.asset(
                                          //     "assets/images/arrow_frwd.svg",
                                          //     height: 0.002.sh,
                                          //     width: 0.002.sw,
                                          //     color: Colors.green,
                                          //   ),
                                          // ),
                                        ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                          // return Padding(
                          //   padding: const EdgeInsets.only(
                          //       bottom: 30.0, left: 20.0, right: 20.0),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       if (title[index] == "Clinician") {
                          //         AppConsts.userType = "1";
                          //         Navigator.pushNamed(
                          //           context,
                          //           Routes.userLogin,
                          //         );
                          //       } else if (title[index] == "Student") {
                          //         AppConsts.userType = "0";
                          //         Navigator.pushNamed(
                          //           context,
                          //           Routes.userLogin,
                          //         );
                          //       }
                          //     },
                          //     child: Container(
                          //       height: 150.sp,
                          //       decoration: BoxDecoration(
                          //         color: Color(Hardcoded.primaryGreen),
                          //         // border: Border.all(color: Color(Hardcoded.primaryGreen)),
                          //         borderRadius: BorderRadius.only(
                          //           bottomRight: Radius.circular(20.0),
                          //           topLeft: Radius.circular(20.0),
                          //         ),
                          //       ),
                          //       child: Padding(
                          //         padding: EdgeInsets.all(7.0),
                          //         child: Stack(
                          //           // mainAxisAlignment: MainAxisAlignment.center,
                          //           // crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: <Widget>[
                          //             Container(
                          //                 height: 100.sp,
                          //                 decoration: BoxDecoration(
                          //                   color: Color(Hardcoded.white),
                          //                   // border: Border.all(color: Color(Hardcoded.primaryGreen)),
                          //                   borderRadius: BorderRadius.only(
                          //                     bottomRight: Radius.circular(20.0),
                          //                     topLeft: Radius.circular(20.0),
                          //                   ),
                          //                 ),
                          //                 child: Stack(children: [],)
                          //             ),
                          //             Expanded(
                          //               child: CircleAvatar(
                          //                 radius: 50,
                          //                 backgroundColor:
                          //                 Color(Hardcoded.primaryGreen),
                          //                 child: Container(
                          //                   width: 80,
                          //                   height: 80,
                          //                   decoration: BoxDecoration(
                          //                     image: DecorationImage(
                          //                         image: NetworkImage(
                          //                             'Network_Image_Link')),
                          //                     color: Color(Hardcoded.white),
                          //                     borderRadius: BorderRadius.all(
                          //                         Radius.circular(50.0)),
                          //                   ),
                          //                   child: SvgPicture.asset(
                          //                     images[index],
                          //                     // height: 35,
                          //                     // errorBuilder: (
                          //                     //   BuildContext context,
                          //                     //   Object error,
                          //                     //   StackTrace? stackTrace,
                          //                     // ) {
                          //                     //   return Container(
                          //                     //     height: 50,
                          //                     //     color: Colors.transparent,
                          //                     //   );
                          //                     //   },
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //             Column(
                          //               crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //               children: <Widget>[
                          //                 Padding(
                          //                   padding: EdgeInsets.only(
                          //                       left: 20.0,  top: 5, bottom: 3, right: 20),
                          //                   child: Text(
                          //                     title[index],
                          //                     overflow: TextOverflow.ellipsis,
                          //                     textAlign: TextAlign.center,
                          //                     maxLines: 3,
                          //                     style: const TextStyle(
                          //                         fontSize: 20,
                          //                         fontWeight: FontWeight.w600,
                          //                         // color: Color.fromARGB(255, 0, 0, 0),
                          //                         color: Colors.orange),
                          //                   ),
                          //                 ),
                          //                 // Padding(
                          //                 //   padding: REdgeInsets.only(
                          //                 //       bottom: 5.0, right: 40.r),
                          //                 //   child: Text(
                          //                 //     subtitle[index],
                          //                 //     overflow: TextOverflow.ellipsis,
                          //                 //     maxLines: 3,
                          //                 //     style: const TextStyle(
                          //                 //         fontSize: 14,
                          //                 //         fontWeight: FontWeight.w400,
                          //                 //         color: Colors.black38
                          //                 //         // color: Color.fromARGB(255, 187, 187, 198),
                          //                 //         ),
                          //                 //   ),
                          //                 // ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: globalHeight * 0.005,
                          // bottom:  globalHeight * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(AppConsts.strBuildVersion,
                              style: TextStyle(
                                  color: Color(Hardcoded.primaryGreen),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
