import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_info.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MpsfBlogDetailScreen extends StatefulWidget {
  final String initialUrl;
  final String htmlString;
  MpsfBlogDetailScreen({Key key, this.initialUrl, this.htmlString})
      : super(key: key);

  @override
  _MpsfBlogDetailScreenState createState() => _MpsfBlogDetailScreenState();
}

class _MpsfBlogDetailScreenState extends State<MpsfBlogDetailScreen>
    with WidgetsBindingObserver, MpsfPageMixin, MpsfContainerMixin {
  WebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('详情'), leading: getBackItem()),
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
      child: WebView(
        initialUrl: "https://www.baidu.com/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          if (widget.htmlString != null) {
            _loadHtmlFromAssets();
          }
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          setContainerStatus(MCIStatus.loading);
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          setContainerStatus(MCIStatus.ready);
        },
        onWebResourceError: (error) {
          Toast.show("${error.description}", context);
          // setContainerStatus(MCIStatus.error);
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
  void onTapBlank() {
    // TODO: implement onTapBlank
    super.onTapBlank();
  }

  @override
  Future<void> clickBackItem() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return;
    }
    super.clickBackItem();
  }

  _loadHtmlFromAssets() async {
    // String fileText = await rootBundle.loadString('assets/help.html');
    String fileText = widget.htmlString;
    _webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
