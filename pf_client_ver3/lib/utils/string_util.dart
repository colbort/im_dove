import 'dart:convert' as convert;
class StringUtil {
  //字符串转Map
  static Map<String, dynamic> stringToMap(String data) {
    if (data == null || data == "") return null;
    Map<String, dynamic> share = convert.jsonDecode(data);
    return share;
  }

  //字符串转Map
  static String mapToString(Map<String, dynamic> data) {
    String str = convert.jsonEncode(data);
    return str;
  }
}
