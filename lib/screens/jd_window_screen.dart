import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:mpsf_app/common/event_bus/event_bus_header.dart';
import 'package:mpsf_app/common/event_bus/event_bus_utils.dart';
import 'package:mpsf_app/common/manager/mpsf_navigator_utils.dart';
import 'package:mpsf_app/screens/login/mpsf_login_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'jd_tabbar_controller_screen.dart';

class JdWindowScreen extends StatefulWidget {
  JdWindowScreen({Key key}) : super(key: key);

  @override
  _JdWindowScreenState createState() => _JdWindowScreenState();
}

class _JdWindowScreenState extends State<JdWindowScreen> {
  var appEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshConfiguration(
        headerBuilder: () =>
            WaterDropHeader(), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
        footerBuilder: () => ClassicFooter(), // 配置默认底部指示器
        headerTriggerDistance: 80.0, // 头部触发刷新的越界距离
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass: 1.9), // 自定义回弹动画,三个属性值意义请查询flutter api
        maxOverScrollExtent: 100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxUnderScrollExtent: 0, // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted:
            true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
        child: JdTabbarControllerScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //添加订阅
    appEvent = eventBus.on<AppEvent>((event) {
      if (event.eventType == AppEventType.Unauthorized) {
        MpsfNavigatorUtils.pushPage(
            context: context, targetPage: MpsfLoginScreen());
      }
    });
  }

  @override
  void dispose() {
    eventBus.off(appEvent);
    super.dispose();
  }
}
