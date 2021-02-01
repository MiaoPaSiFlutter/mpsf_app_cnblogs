import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/screens/home/model/home_news_list_model.dart';
import 'package:mpsf_app/screens/home/widget/home_news_cell.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

/*
  推荐
*/
class ItemRecommended extends StatefulWidget {
  ItemRecommended({Key key}) : super(key: key);

  @override
  _ItemRecommendedState createState() => _ItemRecommendedState();
}

class _ItemRecommendedState extends State<ItemRecommended>
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
          HomeNewsListModel model = _items[index];
          return HomeNewsCell(
            model: model,
            callback: () {
              mpsf_log("${model.toJson}");
            },
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
    ApiService.fetchApi(ApiType.Home_newsitems_recommended,
            page: _page, pageSize: _pageSize)
        .then((respM) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if (_page == 1) {
        _items.clear();
      }
      if (respM.success && respM.data != null && respM.data is List) {
        List list = respM.data;
        for (var map in list) {
          HomeNewsListModel model = HomeNewsListModel.fromJson(map);
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
    // TODO: implement onFetchData
    _onRefresh();
  }

  @override
  // TODO: implement wantKeepAlive
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
