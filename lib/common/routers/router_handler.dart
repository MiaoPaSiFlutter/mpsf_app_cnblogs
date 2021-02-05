import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:mpsf_app/common/routers/fluro_convert_util.dart';
import 'package:mpsf_app/screens/blogdetail/mpsf_newsitems_body_screen.dart';
//Splash
import '../../screens/splash/mpsf_splash_screen.dart';
//主页
import '../../screens/jd_window_screen.dart';
//个人中心
import '../../screens/account/mpsf_browsing_history_screen.dart';
import '../../screens/account/mpsf_my_blogs_screen.dart';
import '../../screens/account/mpsf_my_collect_screen.dart';
import '../../screens/account/mpsf_setting_screen.dart';
//博文详情
import '../../screens/blogdetail/mpsf_blog_detail_screen.dart';
//登陆
import '../../screens/login/mpsf_login_screen.dart';
import '../../screens/login/mpsf_login_authorize_screen.dart';

/// [跳转到首页Splash]
var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfSplashScreen();
});

/// [主页]
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return JdWindowScreen();
});

/// [我的]
/// 浏览历史
var browsingHistoryHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfBrowsingHistoryScreen();
});

/// 收藏
var myCollectHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfMyCollectScreen();
});

/// 设置
var settingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfSettingScreen();
});

/// 我的博客
var myBlogsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  /// 对 中文 进行解码
  String blogApp =
      FluroConvertUtils.fluroCnParamsDecode(params["blogApp"]?.first);

  return MpsfMyBlogsScreen(
    blogApp: blogApp,
  );
});

/// [博客]
/// 博客详情
var blogDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfBlogDetailScreen();
});

/// [登陆]
/// 登陆
var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfLoginScreen();
});

/// 登陆
var loginAuthorizeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MpsfLoginAuthorizeScreen();
});

/// 新闻内容
var newsitemsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  /// 对 中文 进行解码
  String initialUrl =
      FluroConvertUtils.fluroCnParamsDecode(params["initialUrl"]?.first);
  String htmlString =
      FluroConvertUtils.fluroCnParamsDecode(params["htmlString"]?.first);

  return MpsfNewsItemsScreen(
    initialUrl: initialUrl,
    htmlString: htmlString,
  );
});

var demoFunctionHandler = Handler(
  type: HandlerType.function,
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String message = params["message"]?.first;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Hey Hey!",
            style: TextStyle(
              color: const Color(0xFF00D6F7),
              fontFamily: "Lazer84",
              fontSize: 22.0,
            ),
          ),
          content: Text("$message"),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("OK"),
              ),
            ),
          ],
        );
      },
    );
    return;
  },
);
