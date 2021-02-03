import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/screens/blogdetail/mpsf_blog_detail_screen.dart';
import 'package:mpsf_app/screens/home/model/home_list_model.dart';
import 'package:mpsf_app/screens/home/widget/home_cell.dart';
import 'package:mpsf_app/utils/relative_date_format.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

class MpsfMyCollectScreen extends StatefulWidget {
  MpsfMyCollectScreen({Key key}) : super(key: key);

  @override
  _MpsfMyCollectScreenState createState() => _MpsfMyCollectScreenState();
}

class _MpsfMyCollectScreenState extends State<MpsfMyCollectScreen>
    with MpsfCommonFunction {
  List _items = [];
  int _page = 1;
  int _pageSize = 30;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
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
            onFetchData();
          },
          bodyWidget: _buildBodyWidget(),
        ),
      ),
    );
  }

  ///////////////////////////////////////////
  /// 请求
  ///////////////////////////////////////////
  Widget _buildBodyWidget() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          Map model = _items[index];
          return CellItem(
            data: model,
            callback: () {},
          );
        },
        separatorBuilder: (context, index) {
          return Container(color: MpsfHexColor('#E8EDFE'), height: 1);
        },
      ),
    );
  }

  ///////////////////////////////////////////
  /// 请求
  ///////////////////////////////////////////
  void _onRefresh() async {
    _page = 1;
    await loadData();
  }

  void _onLoading() async {
    _page++;
    await loadData();
  }

  Future<void> loadData() async {
    setState(() {
      blankStatus = MpsfBlankStatus.loading;
    });
    ApiService.fetchBookmarks(page: _page, pageSize: _pageSize).then((respM) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();

      if (_page == 1) {
        _items.clear();
      }

      if (respM.success && respM.data != null && respM.data is List) {
        List list = respM.data;
        _items.addAll(list);

        if (list.length < _pageSize) {
          _refreshController.loadNoData();
        }
      } else {
        _page = max(_page--, 1);
      }

      setState(() {
        if (respM.success) {
          blankStatus = MpsfBlankStatus.ready;
        } else {
          blankStatus = MpsfBlankStatus.error;
        }
        if (respM.error != null && respM.error.message != null) {
          Toast.show(respM.error.message, context);
        }
      });
    });
  }

  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  @override
  void onFetchData() {
    _onRefresh();
  }

  @override
  void initState() {
    initBaseCommon(this);
    mpsflog("initState");
    super.initState();
    onFetchData();
  }

  @override
  void didChangeDependencies() {
    mpsflog("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    mpsflog("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    mpsflog("dispose");
    super.dispose();
  }
}

class CellItem extends StatelessWidget {
  final Map data;
  final VoidCallback callback;

  const CellItem({Key key, this.data, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.callback,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle(context),
            _buildTool(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    bool fromCNBlogs = this.data["FromCNBlogs"];
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Text(
        this.data["Title"] ?? "",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333)),
      ),
    );
  }

  Widget _buildTool(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        RelativeDateFormat.getTimeLine(context, this.data["DateAdded"] ?? ""),
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF999999),
        ),
      ),
    );
  }
}
