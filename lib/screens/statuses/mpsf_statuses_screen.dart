import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/mixin/full_screen_dialog_mixin/full_screen_dialog_mixin.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_info.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_app/common/net/network.dart';

import 'package:mpsf_app/utils/relative_date_format.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'mpsf_statuses_vm.dart';
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
        MpsfPageMixin,
        FullScreenDialogMixin,
        MpsfContainerMixin {
  MpsfStatusesVM pageVM = MpsfStatusesVM();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('闪存'), actions: _getAppBarActions()),
      body: buildMpsfContainer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.vertical_align_top, color: Colors.black, size: 40),
        onPressed: () {
          print('FloatingActionButton');
          _listViewController.animateTo(
              _listViewController.position.minScrollExtent,
              duration: const Duration(milliseconds: 10),
              curve: Curves.linear);
        },
        backgroundColor: Colors.yellow,
      ),
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
        controller: _listViewController,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        itemCount: pageVM.items.length,
        itemBuilder: (context, index) {
          StatusesListBean model = pageVM.items[index];
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

  ///导航栏返回键
  List<Widget> _getAppBarActions() {
    List<Widget> actions = [];
    Widget setting = Container(
      width: getNavigationBarHeight(),
      height: double.infinity,
      child: IconButton(
        onPressed: clickFilterItem,
        icon: Icon(Icons.more_horiz),
      ),
    );

    actions.add(setting);
    return actions;
  }

  void clickFilterItem() {
    mpsflog("---clickSettingItem");
    showProgressDialog(afterDismiss: () {
      Toast.show("afterDismiss", context);
    });
    Future.delayed(Duration(seconds: 10))
        .then((value) => dismissProgressDialog());
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

    ApiService.fetchStatusesList("all",
            pageIndex: pageVM.page, pageSize: pageVM.pageSize)
        .then((respM) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();

      if (pageVM.page == 1) {
        pageVM.items.clear();
      }

      if (respM.success && respM.data != null && respM.data is List) {
        List list = respM.data;
        for (var map in list) {
          StatusesListBean model = StatusesListBean.fromJson(map);
          pageVM.items.add(model);
        }

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

  @override
  bool get wantKeepAlive => true;
}

class HomeNewsCell extends StatefulWidget {
  final StatusesListBean model;
  final VoidCallback callback;
  HomeNewsCell({Key key, this.model, this.callback}) : super(key: key);

  @override
  _HomeNewsCellState createState() => _HomeNewsCellState();
}

class _HomeNewsCellState extends State<HomeNewsCell> {
  @override
  void initState() {
    super.initState();
    if (this.widget.model.reqCommonments == false) {
      fetchCommonmentData();
    } else {
      print("评论数据已请求过。");
    }
  }

  fetchCommonmentData() {
    ApiService.fetchStatusesComments("${this.widget.model.id}").then((value) {
      this.widget.model.reqCommonments = true;
      if (value.success) {
        this.widget.model.commonments.addAll(value.data);
        /*
        mounted 是 bool 类型，表示当前 State 是否加载到树⾥。
        常用于判断页面是否释放。
        比如在程序中有些异步的处理，当处理结束时直接调用setState方法会直接报错，
        因为页面已经释放（dispose）了，此时无法渲染页面，这时就可以使用mounted来进行判断页面是否被释放，
        如果释放了就不进行渲染。
        */
        if (mounted) {
          setState(() {});
        }
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    String avatar = this.widget.model?.userIconUrl;
    int itemCount = this.widget.model.commonments.length;

    return GestureDetector(
      onTap: this.widget.callback,
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
                  itemCount > 0
                      ? _buildCommentList(context)
                      : _buildAddNewCommonment(),
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
        RelativeDateFormat.getTimeLine(
            context, this.widget.model.dateAdded ?? ""),
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: '',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: this.widget.model?.userDisplayName ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
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
                      text: this.widget.model?.content ?? "",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildCommentList(BuildContext context) {
    int itemCount = this.widget.model.commonments.length;
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.red,),
        color: Colors.grey[200],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: itemCount > 5 ? 5 : itemCount,
        itemBuilder: (context, index) {
          return _buildCommonment(this.widget.model.commonments[index]);
        },
      ),
    );
  }

  Widget _buildCommonment(dynamic commonment) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MpsfImageView(commonment["UserIconUrl"] ?? "", width: 20, height: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(
                    text: commonment["UserDisplayName"] ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('点击了服务条款');
                      },
                  ),
                  TextSpan(
                    text: ':',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  TextSpan(
                    text: commonment["Content"] ?? "",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewCommonment() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: GestureDetector(
              child: RaisedButton(
                elevation: 30,
                onPressed: _showAddNewCommonentDialog,
                child: Text(
                  "去评论",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showAddNewCommonentDialog() {
    Toast.show("去评论", context);
  }
}
