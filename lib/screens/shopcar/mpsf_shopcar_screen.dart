import 'package:flutter/material.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';

class MpsfShopcarScreen extends StatefulWidget {
  MpsfShopcarScreen({Key key}) : super(key: key);

  @override
  _MpsfShopcarScreenState createState() => _MpsfShopcarScreenState();
}

class _MpsfShopcarScreenState extends State<MpsfShopcarScreen>
    with
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver,
        MpsfPageMixin,
        MpsfContainerMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: buildMpsfContainer(),
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
