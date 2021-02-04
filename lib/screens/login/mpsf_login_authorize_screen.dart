import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mpsf_app/common/config/config.dart';
import 'package:mpsf_app/common/config/net_config.dart';
import 'package:mpsf_app/common/local/local_storage.dart';
import 'package:mpsf_app/common/manager/app_manager.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_info.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/config/net_config.dart';
import 'mpsf_login_authorize_vm.dart';

class MpsfLoginAuthorizeScreen extends StatefulWidget {
  final String initialUrl;
  MpsfLoginAuthorizeScreen({Key key, this.initialUrl}) : super(key: key);

  @override
  _MpsfLoginAuthorizeScreenState createState() =>
      _MpsfLoginAuthorizeScreenState();
}

class _MpsfLoginAuthorizeScreenState extends State<MpsfLoginAuthorizeScreen>
    with WidgetsBindingObserver, MpsfPageMixin, MpsfContainerMixin {
  MpsfLoginAuthorizeVM pageVM = MpsfLoginAuthorizeVM();
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('获取授权码'), leading: getBackItem()),
      body: buildMpsfContainer(),
    );
  }

  ///////////////////////////////////////////
  /// Widget
  ///////////////////////////////////////////
  Widget buildBodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(top: 2),
      child: WebView(
        initialUrl: Uri.encodeFull(pageVM.authorize_url),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          setContainerStatus(MCIStatus.loading);
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          setContainerStatus(MCIStatus.ready);
          //回调地址
          if (url.startsWith(NetConfig.REDIRECT_URI)) {
            url = url.replaceFirst("#", "?");
            Uri u = Uri.parse(url);
            String code = u.queryParameters['code'];
            getAuthorizeToken(code);
            return;
          }
        },
        onWebResourceError: (error) {
          setContainerStatus(MCIStatus.error);
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  void getAuthorizeToken(String code) {
    setContainerStatus(MCIStatus.loading);

    ApiService.getAuthorizeToken(code).then((ApiResultData respM) {
      setContainerStatus(MCIStatus.ready);

      if (respM.success) {
        Toast.show("SUCCESS", context);
        String jsonString = json.encode(respM.data);
        LocalStorage.save(Config.Authorization_Code_Respone, jsonString);
        AppManager().isLogin = true;
      } else {
        Toast.show("${respM.error.message}", context);
      }
      Navigator.pop(context, code);
    });
  }

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
}
