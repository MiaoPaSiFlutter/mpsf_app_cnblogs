import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpsf_app/common/config/net_config.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/config/net_config.dart';

class MpsfLoginAuthorizeScreen extends StatefulWidget {
  final String initialUrl;
  MpsfLoginAuthorizeScreen({Key key, this.initialUrl}) : super(key: key);

  @override
  _MpsfLoginAuthorizeScreenState createState() =>
      _MpsfLoginAuthorizeScreenState();
}

class _MpsfLoginAuthorizeScreenState extends State<MpsfLoginAuthorizeScreen>
    with WidgetsBindingObserver, MpsfCommonFunction {
  WebViewController _webViewController;
  static const String client_id = NetConfig.CLIENT_ID;
  static const String redirect_uri = NetConfig.REDIRECT_URI;
  // ignore: non_constant_identifier_names
  String authorize_url =
      "https://oauth.cnblogs.com/connect/authorize?client_id=$client_id&scope=openid profile CnBlogsApi  offline_access&response_type=code id_token&redirect_uri=$redirect_uri&state=cnblogs.com&nonce=cnblogs.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('获取授权码'),
        leading: getBackItem(),
      ),
      body: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: MpsfBodyContainer(
          blankStatus: blankStatus,
          blankIconPath: blankIconPath,
          blankTitle: blankTitle,
          blankDescription: blankDescription,
          onTapBlank: () {
            _webViewController.reload();
          },
          bodyWidget: _buildBodyWidget(),
        ),
      ),
    );
  }

  ///////////////////////////////////////////
  /// Widget
  ///////////////////////////////////////////
  Widget _buildBodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(top: 2),
      child: WebView(
        initialUrl: Uri.encodeFull(authorize_url),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          blankStatus = MpsfBlankStatus.loading;
          setState(() {});
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          blankStatus = MpsfBlankStatus.ready;
          setState(() {});
          //回调地址
          if (url.startsWith(NetConfig.REDIRECT_URI)) {
            url = url.replaceFirst("#", "?");
            Uri u = Uri.parse(url);
            String code = u.queryParameters['code'];
            Navigator.pop(context, code);
            return;
          }
        },
        onWebResourceError: (error) {
          blankStatus = MpsfBlankStatus.error;
          setState(() {});
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  @override
  void onFetchData() {
    // TODO: implement onFetchData
  }

  @override
  Future<void> clickBackItem() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return;
    }
    super.clickBackItem();
  }

  @override
  void initState() {
    initBaseCommon(this);
    log("initState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    log("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    log("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    log("dispose");
    super.dispose();
  }
}
