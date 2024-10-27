import 'package:clinicaltrac/clinician/view/daily_journal_module/daily_journal_list_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/dr_interaction_list_screen.dart';
import 'package:clinicaltrac/clinician/view/student_attendance_module/student_attendance_list_screen.dart';
import 'package:clinicaltrac/clinician/view/user_profile/view/user_profile_screen.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/dr_interaction_vm_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicianHomeScreen extends StatefulWidget {
  const ClinicianHomeScreen({super.key, required this.pageChange});

  /// page change callback
  final ChangeScreen pageChange;
  @override
  State<ClinicianHomeScreen> createState() => _ClinicianHomeScreenState();
}

class _ClinicianHomeScreenState extends State<ClinicianHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Text(
            "Dashboard",
            style: TextStyle(),
          ),
          SizedBox(
            height: 30.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DrInteractionListScreen(
                        route: DailyJournalRoute.direct)),
              );
            },
            child: Container(
              height: 50.h,
              width: 130.w,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: REdgeInsets.all(8.0),
                child: Center(
                  child: Text("Dr.Interaction"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, Routes.dailyJournalListScreen,);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DailyJournalListScreen(
                        route: DailyJournalRoute.direct)),
              );
            },
            child: Container(
              height: 50.h,
              width: 130.w,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: REdgeInsets.all(8.0),
                child: Center(
                  child: Text("Daily Journal"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, Routes.dailyJournalListScreen,);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentAttendanceListScreen()),
              );
            },
            child: Container(
              height: 50.h,
              width: 130.w,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: REdgeInsets.all(8.0),
                child: Center(
                  child: Text("Student Attendance"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
