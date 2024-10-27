


import 'package:clinicaltrac/clinician/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';

/// View Model for [HomePageScreen]
class UniDrInteractionListScreenVM {

   ClinicianDrInteractionData? drInteractionList;

   RotationListStudentJournal? rotationListStudentJournal;

   Active_status? active_status;

   bool? showAdd;

   Rotation? rotation;
   bool? isFromDashboard;
   UniDrInteractionListScreenVM({this.drInteractionList,this.rotationListStudentJournal,this.active_status,this.showAdd,this.rotation,this.isFromDashboard});

}// ohk


