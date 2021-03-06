import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_info.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_app/common/net/network.dart';

import 'package:mpsf_app/utils/relative_date_format.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'mpsf_my_collect_vm.dart';

class MpsfMyCollectScreen extends StatefulWidget {
  MpsfMyCollectScreen({Key key}) : super(key: key);

  @override
  _MpsfMyCollectScreenState createState() => _MpsfMyCollectScreenState();
}

class _MpsfMyCollectScreenState extends State<MpsfMyCollectScreen>
    with MpsfPageMixin, MpsfContainerMixin {
  MpsfMyCollectVM pageVM = MpsfMyCollectVM();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的收藏'), leading: getBackItem()),
      body: buildMpsfContainer(),
    );
  }

  ///////////////////////////////////////////
  /// 请求
  ///////////////////////////////////////////
  Widget buildBodyWidget() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        itemCount: pageVM.items.length,
        itemBuilder: (context, index) {
          Map model = pageVM.items[index];
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
    pageVM.page = 1;
    await loadData();
  }

  void _onLoading() async {
    pageVM.page++;
    await loadData();
  }

  Future<void> loadData() async {
    setContainerStatus(MCIStatus.loading);

    ApiService.fetchBookmarks(page: pageVM.page, pageSize: pageVM.pageSize)
        .then((respM) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();

      if (pageVM.page == 1) {
        pageVM.items.clear();
      }

      if (respM.success && respM.data != null && respM.data is List) {
        List list = respM.data;
        pageVM.items.addAll(list);

        if (list.length < pageVM.pageSize) {
          _refreshController.loadNoData();
        }
      } else {
        pageVM.page = max(pageVM.page--, 1);
      }

      if (respM.success) {
        setContainerStatus(MCIStatus.ready);
      } else {
        setContainerStatus(MCIStatus.error);
      }
      if (respM.error != null && respM.error.message != null) {
        Toast.show(respM.error.message, context, gravity: Toast.TOP);
      }
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
  void onTapBlank() {
    _onRefresh();
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
