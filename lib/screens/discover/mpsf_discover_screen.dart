import 'package:flutter/material.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';

class MpsfDiscoverScreen extends StatefulWidget {
  MpsfDiscoverScreen({Key key}) : super(key: key);

  @override
  _MpsfDiscoverScreenState createState() => _MpsfDiscoverScreenState();
}

class _MpsfDiscoverScreenState extends State<MpsfDiscoverScreen>
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
        title: Text('发现'),
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
