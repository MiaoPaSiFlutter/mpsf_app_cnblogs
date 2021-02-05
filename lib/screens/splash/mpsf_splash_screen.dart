import 'package:flutter/material.dart';
import 'package:mpsf_app/common/routers/navigator_util.dart';

class MpsfSplashScreen extends StatefulWidget {
  MpsfSplashScreen({Key key}) : super(key: key);

  @override
  _MpsfSplashScreenState createState() => _MpsfSplashScreenState();
}

class _MpsfSplashScreenState extends State<MpsfSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("MpsfSplashScreen")),
      ),
    );
  }

  @override
  void initState() {
    // 2秒后跳转到主页面，上面注释的代码也可以做到倒计时
    Future.delayed(Duration(seconds: 2), () {
      NavigatorUtil.goHomePage(context);
    });
    super.initState();
  }
}
