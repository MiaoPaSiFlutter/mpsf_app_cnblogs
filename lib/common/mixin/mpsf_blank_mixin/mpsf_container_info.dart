class MpsfContainerInfo {
  int status = 0;
  String blankIconPath;
  String blankTitle;
}

class MCIStatus {
  static const int ready = 0; //就绪
  static const int loading = 1; //请求中
  static const int noData = 2; //空数据
  static const int error = 3; //请求错误
}