class Hardcoded {
  //primary green
  static int primaryGreen = 0xFF01A750;

  static int lightBlue = 0x807BB4FF;
  static int lightPurple = 0x80C09FF8;
  static int lightOrange = 0x80FFD682;
  static int lightPink= 0x80E28282;

  ///white
  static int white = 0xFFFFFFFF;
  static int black = 0xFF000000;

  ///textField bg color
  static int textFieldBg = 0xFFF6F9F9;
  static int textFieldBgDisabled = 0xFFEEF0F0;

  ///textField hint color
  static int hintColor = 0xFF4F625F;

  ///faintgreen
  static int greenLight = 0xFFEAFBE2;

  /// orange
  static int orange = 0xFFFF833D;

  ///purple
  static int purple = 0xFF866EE1;

  ///blue
  static int blue = 0xFF3F81FF;

  ///blue
  static int pink = 0xFFFF6666;

  ///divider color
  static int divderColor = 0xFFDDD0D0;

  static int textColor = 0XFF1A203D;

  //hive box key
  static String hiveBoxKey = "userLoginResponse";
  static int shadowColor = 0x4D858484;
  static List<int> dateColor = [0x333F81FF, 0X33876FE1, 0X33FF6868];
  static List<int> dateTextColor = [0xFF3F81FF, 0XFF876FE1, 0XFFFF6868];
  static int noColor = 0X33EE2F1E;
  static int notextColor = 0XFFEE2F1E;
  static int greyText = 0xFF868998;
  static int greyStar = 0XFFD9D9D9;
  static int yellowStar = 0xFFFFC93D;

  ///Month short form list

  static String getMonthString(int? monthInInt) {
    switch (monthInInt) {
      case 1:
        return 'Jan';

      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return '';
  }
}
