import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String login = "/login";
  static String loginAuthorize = "/loginAuthorize";
  static String browsingHistory = "/browsingHistory";
  static String myCollect = "/myCollect";
  static String setting = "/setting";
  static String myBlogs = "/myBlogs";
  static String blogDetail = "/blogDetail";
  static String newsitems = "/newsitems";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });

    /// 第一个参数是路由地址，第二个参数是页面跳转和传参，第三个参数是默认的转场动画，可以看上图
    /// 我这边先不设置默认的转场动画，转场动画在下面会讲，可以在另外一个地方设置（可以看NavigatorUtil类）
    router.define(root, handler: splashHandler);
    router.define(home, handler: homeHandler);
    router.define(browsingHistory, handler: browsingHistoryHandler);
    router.define(myCollect, handler: myCollectHandler);
    router.define(setting, handler: settingHandler);
    router.define(myBlogs, handler: myBlogsHandler);
    router.define(blogDetail, handler: blogDetailHandler);
    router.define(login, handler: loginHandler);
    router.define(loginAuthorize, handler: loginAuthorizeHandler);
    router.define(newsitems, handler: newsitemsHandler);
  }
}
