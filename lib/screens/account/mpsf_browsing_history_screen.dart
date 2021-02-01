import 'package:flutter/material.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/screens/blogdetail/mpsf_blog_detail_screen.dart';
import 'package:mpsf_app/screens/home/model/home_list_model.dart';
import 'package:mpsf_app/screens/home/widget/home_cell.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

class MpsfBrowsingHistoryScreen extends StatefulWidget {
  MpsfBrowsingHistoryScreen({Key key}) : super(key: key);

  @override
  _MpsfBrowsingHistoryScreenState createState() =>
      _MpsfBrowsingHistoryScreenState();
}

class _MpsfBrowsingHistoryScreenState extends State<MpsfBrowsingHistoryScreen>
    with MpsfCommonFunction {
  List _items = [];
  int _page = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('本地浏览历史'),
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
  /// BodyWidget
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
          HomeListModel model = _items[index];
          return HomeCell(
            model: model,
            callback: () {
              MpsfNavigatorUtils.pushPage(
                  context: context,
                  targetPage: MpsfBlogDetailScreen(initialUrl: model.url));
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
    ApiService.fetchApi(ApiType.Home_blogposts, page: _page, pageSize: 30)
        .then((respM) {
      _refreshController.refreshCompleted();

      if (_page == 1) {
        _items.clear();
      }
      if (respM.data != null && respM.data is List) {
        for (var map in respM.data) {
          HomeListModel model = HomeListModel.fromJson(map);
          _items.add(model);
        }
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
    log("initState");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    log("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    log("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    log("dispose");
    super.dispose();
  }
}