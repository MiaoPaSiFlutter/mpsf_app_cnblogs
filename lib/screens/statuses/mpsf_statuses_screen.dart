import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/common/widgets/loading/full_screen_loading_dialog.dart';
import 'package:mpsf_app/utils/relative_date_format.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'statuses_list_bean.dart';

import 'package:mpsf_app/common/screen/page_state.dart';

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
        FullScreenDialogMixin
         {
  List _items = [];
  int _page = 1;
  int _pageSize = 30;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('闪存'),
        actions: _getAppBarActions(),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.vertical_align_top, color: Colors.black, size: 40),
        onPressed: () {
          print('FloatingActionButton');
          _listViewController.animateTo(
              _listViewController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        },
        backgroundColor: Colors.yellow,
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
        controller: _listViewController,
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
    showProgressDialog();
    Future.delayed(Duration(seconds: 2))
        .then((value) => dismissProgressDialog());
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

// ignore: must_be_immutable
class ShowCommonAlert extends Dialog {
  //子布局      =======  意思是说，上下通用，中间的子布局可以当作参数传过来。
  Widget childWidget;
  //左侧按钮
  String negativeText;
  //右侧按钮
  String positiveText;
  //标题
  String title;
  //显示标题下的分隔线
  bool isShowTitleDivi;
  //显示底部确认按钮上的分隔线
  bool isShowBottomDivi;
  //左侧按钮点击事件（取消）
  Function onCloseEvent;
  //右侧按钮点击事件（确认）
  Function onPositivePressEvent;

  //标题默认高度
  double defaultTitleHeight = 40.0;

  ShowCommonAlert({
    Key key,
    @required this.childWidget,
    @required this.title,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    this.isShowTitleDivi = true,
    this.isShowBottomDivi = true,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //白色背景
            new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff), //可以自定义一个颜色传过来
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              child: new Column(
                children: <Widget>[
                  //标题
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: defaultTitleHeight,
                      child: Center(
                        child: new Text(
                          title,
                          style: new TextStyle(
                              fontSize: 16.0, color: Color(0xff666666)),
                        ),
                      ),
                    ),
                  ),
                  //标题下的分隔线
                  new Container(
                    color:
                        isShowTitleDivi ? Color(0xffe0e0e0) : Color(0xffffffff),
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: 1.0,
                  ),
                  //中间显示的Widget
                  new Container(
                    constraints: BoxConstraints(minHeight: 80.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: childWidget,
                    ),
                  ),
                  //底部的分隔线
                  new Container(
                    color: isShowBottomDivi ? Color(0xffe0e0e0) : Colors.white,
                    margin: EdgeInsets.only(top: 10.0),
                    height: 1.0,
                  ),
                  //底部的确认取消按钮
                  this._buildBottomButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return Container(
      height: 54.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widgets,
      ),
    );
  }

  Widget _buildBottomCancelButton() {
    return new FlatButton(
      onPressed: onCloseEvent,
      child: new Text(
        negativeText,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return new FlatButton(
      onPressed: onPositivePressEvent,
      child: new Text(
        positiveText,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
