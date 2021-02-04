import 'package:mpsf_app/screens/login/bean/login_user_bean.dart';

class MpsfAccountVM {
  LoginUserBean loginUser;

  List sections = [
    [
      {"title": "用户信息", "subtitle": ""},
    ],
    [
      {"title": "我的博客", "subtitle": ""},
      {"title": "我的收藏", "subtitle": ""},
      {"title": "浏览历史", "subtitle": ""},
    ],
    [
      {"title": "提交反馈", "subtitle": ""},
    ],
    [
      {"title": "更新内容", "subtitle": ""},
      {"title": "许可", "subtitle": ""},
      {"title": "关于", "subtitle": ""},
    ],
  ];
}
