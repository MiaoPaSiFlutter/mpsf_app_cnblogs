import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/animation/page_route_anim/fade_animation.dart';
import 'package:mpsf_app/common/animation/page_route_anim/no_animation.dart';
import 'package:mpsf_app/common/animation/page_route_anim/size_scale_animation.dart';
import 'package:mpsf_app/common/animation/page_route_anim/slide_animation.dart';

class MpsfNavigatorUtils {
  ///普通打开页面的方法
  ///[context] 上下文对象
  ///[targetPage] 目标页面
  ///[isReplace] 是否替换当前页面  A -B
  static void pushPage({
    @required BuildContext context,
    @required Widget targetPage,
    bool isReplace = false,
    Function(dynamic value) dismissCallBack,
  }) {
    PageRoute pageRoute;

    if (Platform.isAndroid) {
      pageRoute = MaterialPageRoute(builder: (BuildContext context) {
        return targetPage;
      });
    } else {
      // pageRoute = CupertinoPageRoute(builder: (BuildContext context) {
      //   return targetPage;
      // });
      // pageRoute = FadeRouteBuilder(targetPage, null);
      // pageRoute = NoAnimRouteBuilder(targetPage, null);
      // pageRoute = ScaleRouteBuilder(targetPage, null);
      // pageRoute = SlideTopRouteBuilder(targetPage, null);
      // pageRoute = SlideBottomRouteBuilder(targetPage, null);
      pageRoute = SlideRightRouteBuilder(targetPage, null);
    }
    pageRoute = SlideRightRouteBuilder(targetPage, null);

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    }
  }

  ///普通打开页面的方法
  ///[context] 上下文对象
  ///[targetPage] 目标页面
  ///[isReplace] 是否替换当前页面  A -B
  ///[opaque] 是否以背景透明的方式打开页面
  static void pushPageByFade({
    @required BuildContext context,
    @required Widget targetPage,
    bool isReplace = false,
    int startMills = 400,
    bool opaque = false,
    Function(dynamic value) dismissCallBack,
  }) {
    PageRoute pageRoute = PageRouteBuilder(
      //背景透明 方式打开新的页面
      opaque: opaque,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return targetPage;
      },
      transitionDuration: Duration(milliseconds: startMills),
      //动画
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    }
  }
}
