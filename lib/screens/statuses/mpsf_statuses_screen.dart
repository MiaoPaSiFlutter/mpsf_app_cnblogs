import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/utils/relative_date_format.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'statuses_list_bean.dart';

class MpsfStatusesScreen extends StatefulWidget {
  MpsfStatusesScreen({Key key}) : super(key: key);

  @override
  _MpsfCategoryScreenState createState() => _MpsfCategoryScreenState();
}

class _MpsfCategoryScreenState extends State<MpsfStatusesScreen>
    with
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver,
        MpsfCommonFunction {
  List _items = [];
  int _page = 1;
  int _pageSize = 30;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('闪存'),
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
          StatusesListBean model = _items[index];
          return HomeNewsCell(
            model: model,
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
    ApiService.fetchStatusesList("all", pageIndex: _page, pageSize: _pageSize)
        .then((respM) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();

      if (_page == 1) {
        _items.clear();
      }

      if (respM.success && respM.data != null && respM.data is List) {
        List list = respM.data;
        for (var map in list) {
          StatusesListBean model = StatusesListBean.fromJson(map);
          _items.add(model);
        }

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    initBaseCommon(this);
    mpsf_log("initState");
    super.initState();
    onFetchData();
  }

  @override
  void didChangeDependencies() {
    mpsf_log("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    mpsf_log("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    mpsf_log("dispose");
    super.dispose();
  }
}

class HomeNewsCell extends StatelessWidget {
  final StatusesListBean model;
  final VoidCallback callback;

  const HomeNewsCell({Key key, this.model, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String avatar = this.model?.userIconUrl;
    return GestureDetector(
      onTap: this.callback,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MpsfImageView(avatar, width: 50, height: 50),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildDateAdded(context),
                  _buildDescription(context),
                  // _buildTool(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateAdded(BuildContext context) {
    return Container(
      child: Text(
        RelativeDateFormat.getTimeLine(context, this.model.dateAdded ?? ""),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: this.model?.userDisplayName ?? "",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('点击了服务条款');
                        },
                    ),
                    TextSpan(
                      text: ':',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextSpan(
                      text: this.model?.content ?? "",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildTool(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  "${this.model?.commentCount} 评论   ",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
