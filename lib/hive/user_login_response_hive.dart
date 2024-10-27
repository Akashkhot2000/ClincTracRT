import 'package:hive/hive.dart';

part 'user_login_response_hive.g.dart';

@HiveType(typeId: 0)

///
class UserLoginResponseHive extends HiveObject {
  // String loggedUserId;
  // String accessToken;
  // String loggedUserRankTitle;
  // String loggedUserFirstName;
  // String loggedUserMiddleName;
  // String loggedUserLastName;
  // String loggedUserEmail;
  // String loggedUserProfile;
  // String loggedUserSchoolName;

  ///userId
  @HiveField(0, defaultValue: "")
  late String loggedUserId;

  ///accessToken
  @HiveField(1, defaultValue: "")
  late String accessToken;

  ///Rank title
  @HiveField(2, defaultValue: "")
  late String loggedUserRankTitle;

  ///firstName
  @HiveField(3, defaultValue: "")
  late String loggedUserFirstName;

  ///middleName
  @HiveField(4, defaultValue: "")
  late String loggedUserMiddleName;

  ///lastName
  @HiveField(5, defaultValue: "")
  late String loggedUserLastName;

  ///email
  @HiveField(6, defaultValue: "")
  late String loggedUserEmail;

  ///userProfileImage
  @HiveField(7, defaultValue: "")
  late String loggedUserProfile;

  ///schoolname
  @HiveField(8, defaultValue: "")
  late String loggedUserSchoolName;

  @HiveField(9, defaultValue: "")
  late String loggedUserSchoolType;

  @HiveField(10, defaultValue: "")
  late String loggedUserloginhistoryId;

  @HiveField(11, defaultValue: "")
  late String loggedUserType;

  @HiveField(12, defaultValue: "")
  late String loggedUserRole;

  @HiveField(13, defaultValue: "")
  late String loggedUserRoleType;
}
