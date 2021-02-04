import 'package:flutter/material.dart';
import 'package:mpsf_app/common/manager/mpsf_navigator_utils.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_info.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/screens/blogdetail/mpsf_blog_detail_screen.dart';
import 'package:mpsf_app/screens/home/model/home_list_model.dart';
import 'package:mpsf_app/screens/home/widget/home_cell.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'mpsf_browsing_history_vm.dart';

class MpsfBrowsingHistoryScreen extends StatefulWidget {
  MpsfBrowsingHistoryScreen({Key key}) : super(key: key);

  @override
  _MpsfBrowsingHistoryScreenState createState() =>
      _MpsfBrowsingHistoryScreenState();
}

class _MpsfBrowsingHistoryScreenState extends State<MpsfBrowsingHistoryScreen>
    with MpsfPageMixin, MpsfContainerMixin {
  MpsfBrowsingHistoryVM pageVM = MpsfBrowsingHistoryVM();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('本地浏览历史'), leading: getBackItem()),
      body: Container(
        child: buildMpsfContainer(),
      ),
    );
  }

  ///////////////////////////////////////////
  /// BodyWidget
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
          HomeListModel model = pageVM.items[index];
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
    pageVM.page = 1;
    await loadData();
  }

  void _onLoading() async {
    pageVM.page++;
    await loadData();
  }

  Future<void> loadData() async {
    setContainerStatus(MCIStatus.loading);
    ApiService.fetchApi(ApiType.Home_blogposts, page: pageVM.page, pageSize: 30)
        .then((respM) {
      _refreshController.refreshCompleted();

      if (pageVM.page == 1) {
        pageVM.items.clear();
      }
      if (respM.data != null && respM.data is List) {
        for (var map in respM.data) {
          HomeListModel model = HomeListModel.fromJson(map);
          pageVM.items.add(model);
        }
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
