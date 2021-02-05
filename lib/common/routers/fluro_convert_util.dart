import 'dart:convert';

/// fluro 参数编码解码工具类
class FluroConvertUtils {
  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String fluroCnParamsEncode(String originalCn) {
    try {
      return jsonEncode(Utf8Encoder().convert(originalCn));
    } catch (e) {
      return null;
    }
  }

  /// fluro 传递后取出参数，解析
  static String fluroCnParamsDecode(String encodeCn) {
    try {
      var list = List<int>();

      ///字符串解码
      jsonDecode(encodeCn).forEach(list.add);
      String value = Utf8Decoder().convert(list);
      return value;
    } catch (e) {
      return null;
    }
  }

  /// string 转为 int
  static int string2int(String str) {
    try {
      return int.parse(str);
    } catch (e) {
      return null;
    }
  }

  /// string 转为 double
  static double string2double(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return null;
    }
  }

  /// string 转为 bool
  static bool string2bool(String str) {
    if (str == 'true') {
      return true;
    } else {
      return false;
    }
  }

  /// object 转为 string json
  static String object2string<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> string2map(String str) {
    try {
      return json.decode(fluroCnParamsDecode(str));
    } catch (e) {
      return null;
    }
  }
}
