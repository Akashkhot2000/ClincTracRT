import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/daily_journal_list_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/dr_interaction_list_screen.dart';
import 'package:clinicaltrac/common/coming_soon_screen_widget.dart';
import 'package:clinicaltrac/common/common_change_hospitalsite_widget.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/menu_add_remove_model.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/vm_connector/pef_eval_vm_connector.dart';
import 'package:clinicaltrac/view/ci/vm_connector/ci_vm_connector.dart';
import 'package:clinicaltrac/view/daily_journal/vm_connector/daily_journal_vm_connector.dart';
import 'package:clinicaltrac/view/daily_weekly/vm_connector/daily_weekly_vm_connector.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/dr_interaction_vm_conector.dart';
import 'package:clinicaltrac/view/equipment/vm_connector/equipment_vm_connector.dart';
import 'package:clinicaltrac/view/exception_dashboard/view/CreateExceptionScreen.dart';
import 'package:clinicaltrac/view/floor_therapy/vm_connector/floor_vm_list_connector.dart';
import 'package:clinicaltrac/view/formative/vm_connector/formative_vm_connector.dart';
import 'package:clinicaltrac/view/incident/vm_connector/incident_vm_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/mastery_evaluation/vm_connector/mastery_evaluation_vm_connector.dart';
import 'package:clinicaltrac/view/midterm_evaluation/Vm_conector/midterm_eval_vm_conector.dart';
import 'package:clinicaltrac/view/p_evaluation/model/p_eval_vm_connector.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/rotations/view/createRotationException.dart';
import 'package:clinicaltrac/view/site_evaluation/vm_conector/site_eval_vm_conector.dart';
import 'package:clinicaltrac/view/summative/vm_connector/summative_vm_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClinicianCommonGridWidget extends StatefulWidget {
  ClinicianCommonGridWidget(
      {super.key,
        required this.gridImagePathList,
        required this.gridTitleList,
        required this.activeOptions,
        required this.rotationDetailListData,
        // required this.onTapSendMail
      });

  final List<String> gridImagePathList;
  final List<String> gridTitleList;
  final List<int> activeOptions;
  final ClinicianRotationDetailListData rotationDetailListData;
  // final Function() onTapSendMail;

  @override
  State<ClinicianCommonGridWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ClinicianCommonGridWidget> {
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 1,
        childAspectRatio: 1.08,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.gridImagePathList.length,
      itemBuilder: (BuildContext context, int index) {
        // log("-------------${widget.gridImagePathList.length}");
        return GestureDetector(
          onTap: () {
            // switch (index) {
            switch (widget.activeOptions[index]) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  DrInteractionListScreen(
                      route: DailyJournalRoute
                          .rotation,
                    rotationDetailListData: widget.rotationDetailListData,
                  )),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  DailyJournalListScreen(
                      route: DailyJournalRoute
                          .rotation,
                    rotationDetailListData: widget.rotationDetailListData,
                  )),
                );
                break;
              // case 2:
              //   Navigator.pushNamed(context, Routes.formativeScreen,
              //       arguments: FormativeRoutingData(rotation: widget.rotation, route: DailyJournalRoute.rotation));
              //   break;
              // case 3:
              //   Navigator.pushNamed(context, Routes.dailyWeeklyScreen,
              //       arguments:
              //       DailyWeeklyRoutingData(rotation: widget.rotation, route: DailyJournalRoute.rotation));
              //   break;
              // case 4:
              // // Navigator.push(context,MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true,title: "Midterm",)),);
              //   Navigator.pushNamed(context, Routes.midtermEvaluationScreen,
              //       arguments: GetMidtermEvalListRoutingData(
              //           rotation: widget.rotation, route: DailyJournalRoute.rotation));
              //   break;
              // case 5:
              // // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "Summative",)),);
              //   Navigator.pushNamed(context, Routes.summativeScreen,
              //       arguments: SummativeRoutingData(rotation: widget.rotation, route: DailyJournalRoute.rotation));
              //   break;
              // case 6:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => CominSoonScreen(
              //             isAppbar: true,
              //             title: "Mastery Evaluation",
              //           )),
              // );
              //   ;
              //   Navigator.pushNamed(context, Routes.masteryListScreen,
              //       arguments: new MasteryEvaluationRoutingData(
              //           rotation: widget.rotation));
              //   break;
              // case 7:
              // // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "CI Evaluation",)),);
              //   Navigator.pushNamed(context, Routes.ciScreen,
              //       arguments: CIRoutingData(rotation: widget.rotation));
              //   break;
              // case 8:
              // // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "P Evaluation",)),);
              //   Navigator.pushNamed(context, Routes.pEvaluationScreen,
              //       arguments:
              //       GetPEvalListRoutingData(rotation: widget.rotation));
              //   break;
              // case 9:
              // // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "Site Evaluation",)),);
              //   Navigator.pushNamed(context, Routes.siteEvalListScreen,
              //       arguments:
              //       SiteEvaluationRoutingData(rotation: widget.rotation));
              //   break;
              // case 10:
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CominSoonScreen(
              //           isAppbar: true,
              //           title: "Volunteer Evaluation",
              //         )),
              //   );
              //   break;
            // case 11:  Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true,title: "Exception",)),
            // );
            // break;
            //   case 11:
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => CreateRotationExceptionScreen(
            //           rotation: widget.rotation,
            //         ),
            //       ),
            //     );
            //     break;
            //   case 12:
            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "Floor Theory & ICU Evaluation",)),);
            //     Navigator.pushNamed(context, Routes.floorEvaluationScreen,
            //         arguments:
            //         GetFloorListRoutingData(rotation: widget.rotation));
            //     break;
            //   case 13:
            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "PEF Evaluation",)),);
            //     Navigator.pushNamed(context, Routes.pefEvaluationScreen,
            //         arguments:
            //         GetPefEvalListRoutingData(rotation: widget.rotation));
            //     break;
            //   case 14:
            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => CominSoonScreen(isAppbar: true, title: "Equipment List",)),);
            //     Navigator.pushNamed(context, Routes.equipmentListScreen,
            //         arguments:
            //         GetEquipmentListRoutingData(rotation: widget.rotation));
            //     break;
            //   case 15:
            //     Navigator.pushNamed(context, Routes.incidentScreen,
            //         arguments:
            //         DailyRoutingDetails(route: DailyJournalRoute.direct,rotation: widget.rotation));
            //     break;
            //   case 16:
            //     showModalBottomSheet<void>(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.vertical(
            //           top: Radius.circular(30.0),
            //         ),
            //       ),
            //       context: context,
            //       isScrollControlled: true,
            //       builder: (BuildContext context) {
            //         return ChangeHospitalSiteBottomSheet(
            //           userId: box!
            //               .get(Hardcoded.hiveBoxKey)!
            //               .loggedUserId,
            //           accessToken: box!
            //               .get(Hardcoded.hiveBoxKey)!
            //               .accessToken,
            //           rotationId:
            //           widget.rotation.rotationId,
            //           // preceptorId: widget.rotation.,
            //           isClockIn:  widget.rotation.isClockIn,
            //           hospitalSiteId: widget.rotation.hospitalSiteId,
            //           hospitalSiteTitle: widget.rotation.hospitalTitle,
            //         );
            //       },
            //     );
            // // widget.onTapSendMail;
            // // Navigator.push(
            // //   context,
            // //   MaterialPageRoute(builder: (context) => ChangeHospitalSiteBottomSheet(
            // //     userId: box!
            // //         .get(Hardcoded.hiveBoxKey)!
            // //         .loggedUserId,
            // //     accessToken: box!
            // //         .get(Hardcoded.hiveBoxKey)!
            // //         .accessToken,
            // //     rotationId:
            // //     widget.rotation.rotationId,
            // //     // preceptorId: widget.rotation.,
            // //     isClockIn:  widget.rotation.isClockIn,
            // //     hospitalSiteId: widget.rotation.rotationId,
            // //     hospitalSiteTitle: widget.rotation.hospitalTitle,
            // //   )),
            // // );
            // // break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(
              //   height: 25,
              // ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                height: 60,
                width: 60,
                // decoration: BoxDecoration(shape: BoxShape.circle, color: Color(Hardcoded.greenLight)),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child:
                  widget.gridImagePathList.elementAt(index).contains('.png')
                      ? Image.asset(
                    widget.gridImagePathList.elementAt(index),
                  )
                      : SvgPicture.asset(
                    widget.gridImagePathList.elementAt(index),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    widget.gridTitleList.elementAt(index),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
