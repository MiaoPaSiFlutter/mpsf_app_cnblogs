import 'package:flutter/material.dart';
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
        MpsfPageMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
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
