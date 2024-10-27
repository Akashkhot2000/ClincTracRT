// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_response_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLoginResponseHiveAdapter extends TypeAdapter<UserLoginResponseHive> {
  @override
  final int typeId = 0;

  @override
  UserLoginResponseHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLoginResponseHive()
      ..loggedUserId = fields[0] != null ? fields[0] as String : ""
      ..accessToken = fields[1] != null ? fields[1] as String : ""
      ..loggedUserRankTitle = fields[2] != null ? fields[2] as String : ""
      ..loggedUserFirstName = fields[3] != null ? fields[3] as String : ""
      ..loggedUserMiddleName = fields[4] != null ? fields[4] as String : ""
      ..loggedUserLastName = fields[5] != null ? fields[5] as String : ""
      ..loggedUserEmail = fields[6] != null ? fields[6] as String : ""
      ..loggedUserProfile = fields[7] != null ? fields[7] as String : ""
      ..loggedUserSchoolName = fields[8] != null ? fields[8] as String : ""
      ..loggedUserSchoolType = fields[9] != null ? fields[9] as String : ""
      ..loggedUserloginhistoryId =
          fields[10] != null ? fields[10] as String : ""
      ..loggedUserType = fields[11] != null ? fields[11] as String : ""
      ..loggedUserRole = fields[12] != null ? fields[12] as String : ""
      ..loggedUserRoleType = fields[13] != null ? fields[13] as String : "";
  }

  @override
  void write(BinaryWriter writer, UserLoginResponseHive obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.loggedUserId)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.loggedUserRankTitle)
      ..writeByte(3)
      ..write(obj.loggedUserFirstName)
      ..writeByte(4)
      ..write(obj.loggedUserMiddleName)
      ..writeByte(5)
      ..write(obj.loggedUserLastName)
      ..writeByte(6)
      ..write(obj.loggedUserEmail)
      ..writeByte(7)
      ..write(obj.loggedUserProfile)
      ..writeByte(8)
      ..write(obj.loggedUserSchoolName)
      ..writeByte(9)
      ..write(obj.loggedUserSchoolType)
      ..writeByte(10)
      ..write(obj.loggedUserloginhistoryId)
      ..writeByte(11)
      ..write(obj.loggedUserType)
      ..writeByte(12)
      ..write(obj.loggedUserRole)
      ..writeByte(13)
      ..write(obj.loggedUserRoleType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoginResponseHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
