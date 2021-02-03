import 'package:flutter/material.dart';
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
        MpsfPageMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('发现'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red)
        ),
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}