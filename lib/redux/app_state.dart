import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/model/ActiveRotationStatus.dart';
import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/menu_add_remove_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/course_topic_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_details_response.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:clinicaltrac/view/home/model/stud_dashboard_model.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/medical_treminology/model/medical_terminology_model.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/profile/model/country_list_model.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';

/// [AppState] represents the overall Redux state of the application.
class AppState {
  /// Constructor for [AppState]
  AppState(
      {required this.userLoginResponse,
      required this.studentDetailsResponse,
      required this.countryList,
      required this.rotationListModel,
      required this.allRotationListModel,
      required this.activeRotationListModel,
      required this.studDashboardModel,
      required this.medicalTerminologyModel,
      required this.courseListModel,
      required this.rotationForEvalListModel,
      required this.courseTopicListModel,
      required this.allCourseTopicListModel,
      required this.active_status,
      required this.isProfileEditable,
      required this.rotationListStudentJournal,
      required this.hospitalUnitListResponseDart,
      required this.procedureCountModel,
      required this.drInteractionList,
      required this.clinicianDataList,
      required this.attendanceResponseDart,
      required this.midtermEvalList,
      required this.dailyJournalDetailsResponse,
      required this.studentCheckoffsListModel,
      required this.menuAddRemoveModel,
      required this.activeRotationStatus});

  final UserLoginResponse userLoginResponse;
  final StudentDetailsResponse studentDetailsResponse;
  final CountryList countryList;
  final RotationListModel rotationListModel;
  final AllRotationListModel allRotationListModel;
  final ActiveRotationListModel activeRotationListModel;
  final StudDashboardModel studDashboardModel;
  final MedicalTerminologyModel medicalTerminologyModel;
  final CourseListModel courseListModel;
  final RotationForEvalListModel rotationForEvalListModel;
  final CourseTopicListModel courseTopicListModel;
  final CourseTopicListModel allCourseTopicListModel;
  final Active_status active_status;
  final bool isProfileEditable;
  final RotationListStudentJournal rotationListStudentJournal;
  final HospitalUnitListResponseDart hospitalUnitListResponseDart;
  final ProcedureCountModel procedureCountModel;
  final StudentDrInteractionData drInteractionList;
  final ActiveRotationStatus activeRotationStatus;
  final MidtermEvalList midtermEvalList;
  final DailyJournalDetailsResponse dailyJournalDetailsResponse;
  final MenuAddRemoveModel menuAddRemoveModel;

  final ClinicianDataList clinicianDataList;
  final StudentCheckoffsListModel studentCheckoffsListModel;

  final AttendanceResponseDart attendanceResponseDart;

  /// the set the initial value for the corresponding variables if any
  static Future<AppState> initialState() async {
    return AppState(
      userLoginResponse: UserLoginResponse(
          data: Data(
        loggedUserId: '',
        accessToken: '',
        loggedUserRankTitle: '',
        loggedUserRole: '',
        loggedUserRoleType: '',
        loggedUserType: '',
        loggedUserFirstName: '',
        loggedUserMiddleName: '',
        loggedUserLastName: '',
        loggedUserEmail: '',
        loggedUserProfile: '',
        loggedUserSchoolName: '',
        loggedUserSchoolType: '',
        loggedUserloginhistoryId: '',
      )),
      clinicianDataList: ClinicianDataList(data: []),
      studentDetailsResponse: StudentDetailsResponse(
          data: Datastd(
        accessToken: '',
        loggedUserAddress1: '',
        loggedUserAddress2: '',
        loggedUserEmail: '',
        loggedUserFirstName: '',
        loggedUserId: '',
        loggedUserLastName: '',
        loggedUserMiddleName: '',
        loggedUserName: '',
        loggedUserProfile: '',
        loggedUserRankTitle: '',
        city: '',
        countryId: "",
        countryName: '',
        stateId: '',
        stateName: '',
        zipCode: '',
      )),
      countryList: CountryList(data: []),
      rotationListModel: RotationListModel(
          data: RotaionListData(
              isClockedIn: false, rotationList: [], pendingRotation: []),
          pager: Pager()),
      allRotationListModel: AllRotationListModel(data: [], pager: Pager()),
      activeRotationListModel: ActiveRotationListModel(
          data: ActiveRotaionListData(
              isClockedIn: false, rotationList: [], pendingRotation: [])),
      studDashboardModel: StudDashboardModel(
          data: StudDashboardListData(
              attendanceCount: '',
              checkoffCount: '',
              interactionCount: '',
              incidentCount: '',
              journalCount: '',
              procedureCount: '',
              loggedUserDetails: LoggedUserDetails(
                loggedUserEmail: '',
                loggedUserFirstName: '',
                loggedUserLastName: '',
                loggedUserMiddleName: '',
                loggedUserProfile: '',
                loggedUserSchoolImagePath: '',
                loggedUserSchoolName: '',
              ))),
      medicalTerminologyModel:
          MedicalTerminologyModel(data: [], pager: Pager()),
      courseListModel: CourseListModel(data: []),
      rotationForEvalListModel: RotationForEvalListModel(data: []),
      courseTopicListModel: CourseTopicListModel(data: []),
      allCourseTopicListModel: CourseTopicListModel(data: []),
      active_status: Active_status.active,
      isProfileEditable: false,
      drInteractionList: StudentDrInteractionData(
          data: DrInteractionData(
              interactionDescriptionCount: '', interactionList: []),
          pager: Pager()),
      dailyJournalDetailsResponse: DailyJournalDetailsResponse(
          data: DailyJournalDetailsData(
        journalId: '',
        rotationId: '',
        rotationName: '',
        hospitalSiteUnitId: '',
        hospitalSiteunitName: '',
        hospitalSiteId: '',
        hospitalName: '',
        journalDate: '',
        schoolResponse: false,
        clinicianResponse: false,
        studentResponseForEdit: '',
        schoolResponseForEdit: '',
        clinicianResponseForEdit: '',
      )),
      rotationListStudentJournal: RotationListStudentJournal(data: []),
      hospitalUnitListResponseDart: HospitalUnitListResponseDart(data: []),
      procedureCountModel: ProcedureCountModel(data: [], pager: Pager()),
      activeRotationStatus: ActiveRotationStatus(isRotationActive: false),
      attendanceResponseDart: AttendanceResponseDart(data: [], pager: Pager()),
      studentCheckoffsListModel:
          StudentCheckoffsListModel(data: [], pager: Pager()),
      midtermEvalList: MidtermEvalList(data: [], pager: Pager()),
      menuAddRemoveModel: MenuAddRemoveModel(
          data: MenuAddRemoveData(
        attendance: false,
        caseStudy: false,
        incident: false,
        briefcase: false,
        exception: false,
        medicalTerminology: false,
        chat: false,
        cIEvaluation: false,
        pEvaluation: false,
        dailyJournal: false,
        pEFEvaluation: false,
        dailyWeekly: false,
        drInteraction: false,
        equipmentList: false,
        floorTherapyAndICU: false,
        formative: false,
        help: false,
        volunterEvaluation: false,
        masteryEvaluation: false,
        midterm: false,
        siteEvaluation: false,
        summative: false,
      )),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          clinicianDataList == other.clinicianDataList &&
          active_status == other.active_status &&
          userLoginResponse == other.userLoginResponse &&
          studentDetailsResponse == other.studentDetailsResponse &&
          medicalTerminologyModel == other.medicalTerminologyModel &&
          courseListModel == other.courseListModel &&
          rotationForEvalListModel == other.rotationForEvalListModel &&
          courseTopicListModel == other.courseTopicListModel &&
          allCourseTopicListModel == other.allCourseTopicListModel &&
          midtermEvalList == other.midtermEvalList &&
          isProfileEditable == other.isProfileEditable &&
          rotationListModel == other.rotationListModel &&
          allRotationListModel == other.allRotationListModel &&
          activeRotationListModel == other.activeRotationListModel &&
          rotationListStudentJournal == other.rotationListStudentJournal &&
          hospitalUnitListResponseDart == other.hospitalUnitListResponseDart &&
          procedureCountModel == other.procedureCountModel &&
          drInteractionList == other.drInteractionList &&
          studDashboardModel == other.studDashboardModel &&
          attendanceResponseDart == other.attendanceResponseDart &&
          studentCheckoffsListModel == other.studentCheckoffsListModel &&
          menuAddRemoveModel == other.menuAddRemoveModel &&
          activeRotationStatus == other.activeRotationStatus;

  @override
  int get hashCode =>
      clinicianDataList.hashCode ^
      active_status.hashCode ^
      midtermEvalList.hashCode ^
      userLoginResponse.hashCode ^
      studentDetailsResponse.hashCode ^
      rotationListModel.hashCode ^
      allRotationListModel.hashCode ^
      activeRotationListModel.hashCode ^
      studDashboardModel.hashCode ^
      drInteractionList.hashCode ^
      medicalTerminologyModel.hashCode ^
      courseListModel.hashCode ^
      allCourseTopicListModel.hashCode ^
      rotationForEvalListModel.hashCode ^
      courseTopicListModel.hashCode ^
      isProfileEditable.hashCode ^
      rotationListStudentJournal.hashCode ^
      hospitalUnitListResponseDart.hashCode ^
      procedureCountModel.hashCode ^
      countryList.hashCode ^
      attendanceResponseDart.hashCode ^
      studentCheckoffsListModel.hashCode ^
      menuAddRemoveModel.hashCode ^
      activeRotationStatus.hashCode;

  /// Copy Constructor creates a copy of the variable and stores the value into it
  AppState copy({
    ClinicianDataList? clinicianDataList,
    UserLoginResponse? userLoginResponse,
    Active_status? active_status,
    StudentDetailsResponse? studentDetailsResponse,
    RotationListModel? rotationListModel,
    ActiveRotationListModel? activeRotationListModel,
    StudDashboardModel? studDashboardModel,
    MedicalTerminologyModel? medicalTerminologyModel,
    CourseListModel? courseListModel,
    RotationForEvalListModel? rotationForEvalListModel,
    CourseTopicListModel? courseTopicListModel,
    CourseTopicListModel? allCourseTopicListModel,
    MidtermEvalList? midtermEvalList,
    DailyJournalDetailsResponse? dailyJournalDetailsResponse,
    bool? isProfileEditable,
    CountryList? countryList,
    StudentDrInteractionData? drInteractionList,
    RotationListStudentJournal? rotationListStudentJournal,
    HospitalUnitListResponseDart? hospitalUnitListResponseDart,
    ProcedureCountModel? procedureCountModel,
    ActiveRotationStatus? activeRotationStatus,
    AttendanceResponseDart? attendanceResponseDart,
    StudentCheckoffsListModel? studentCheckoffsListModel,
    AllRotationListModel? allRotationListModel,
    MenuAddRemoveModel? menuAddRemoveModel,
  }) =>
      AppState(
        attendanceResponseDart:
            attendanceResponseDart ?? this.attendanceResponseDart,
        clinicianDataList: clinicianDataList ?? this.clinicianDataList,
        active_status: active_status ?? this.active_status,
        drInteractionList: drInteractionList ?? this.drInteractionList,
        userLoginResponse: userLoginResponse ?? this.userLoginResponse,
        rotationListModel: rotationListModel ?? this.rotationListModel,
        allRotationListModel: allRotationListModel ?? this.allRotationListModel,
        midtermEvalList: midtermEvalList ?? this.midtermEvalList,
        activeRotationListModel:
            activeRotationListModel ?? this.activeRotationListModel,
        studDashboardModel: studDashboardModel ?? this.studDashboardModel,
        studentDetailsResponse:
            studentDetailsResponse ?? this.studentDetailsResponse,
        medicalTerminologyModel:
            medicalTerminologyModel ?? this.medicalTerminologyModel,
        dailyJournalDetailsResponse:
            dailyJournalDetailsResponse ?? this.dailyJournalDetailsResponse,
        courseListModel: courseListModel ?? this.courseListModel,
        rotationForEvalListModel:
            rotationForEvalListModel ?? this.rotationForEvalListModel,
        courseTopicListModel: courseTopicListModel ?? this.courseTopicListModel,
        allCourseTopicListModel:
            allCourseTopicListModel ?? this.allCourseTopicListModel,
        isProfileEditable: isProfileEditable ?? this.isProfileEditable,
        countryList: countryList ?? this.countryList,
        rotationListStudentJournal:
            rotationListStudentJournal ?? this.rotationListStudentJournal,
        hospitalUnitListResponseDart:
            hospitalUnitListResponseDart ?? this.hospitalUnitListResponseDart,
        procedureCountModel: procedureCountModel ?? this.procedureCountModel,
        studentCheckoffsListModel:
            studentCheckoffsListModel ?? this.studentCheckoffsListModel,
        activeRotationStatus: activeRotationStatus ?? this.activeRotationStatus,
        menuAddRemoveModel: menuAddRemoveModel ?? this.menuAddRemoveModel,
      );
}
