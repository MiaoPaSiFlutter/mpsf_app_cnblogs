
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mpsf_app/common/net/network.dart';
import 'package:mpsf_app/common/widgets/blank/mpsf_empty_widget.dart';
import 'package:mpsf_app/common/widgets/cell/mpsf_cell.dart';
import 'package:mpsf_app/screens/account/mpsf_my_blogs_screen.dart';
import 'package:mpsf_app/screens/account/mpsf_my_collect_screen.dart';
import 'package:mpsf_app/screens/login/bean/login_user_bean.dart';
import 'package:mpsf_app/screens/login/mpsf_login_authorize_screen.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import 'mpsf_browsing_history_screen.dart';
import 'mpsf_setting_screen.dart';

class MpsfAccountScreen extends StatefulWidget {
  MpsfAccountScreen({Key key}) : super(key: key);

  @override
  _MpsfAccountScreenState createState() => _MpsfAccountScreenState();
}

class _MpsfAccountScreenState extends State<MpsfAccountScreen>
    with
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver,
        MpsfCommonFunction {
  List _sections = [
    [
      {"title": "用户信息", "subtitle": ""},
    ],
    [
      {"title": "我的博客", "subtitle": ""},
      {"title": "我的收藏", "subtitle": ""},
      {"title": "浏览历史", "subtitle": ""},
    ],
    [
      {"title": "提交反馈", "subtitle": ""},
    ],
    [
      {"title": "更新内容", "subtitle": ""},
      {"title": "许可", "subtitle": ""},
      {"title": "关于", "subtitle": ""},
    ],
  ];
  LoginUserBean _loginUser;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text("我的"), actions: _getAppBarActions()),
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
      onLoading: null,
      child: Container(
        color: Theme.of(context).dividerColor,
        child: GroupListView(
          padding: EdgeInsets.all(0),
          sectionsCount: _sections.length,
          countOfItemInSection: (int section) {
            return _sections[section].length;
          },
          itemBuilder: _itemBuilder,
          groupHeaderBuilder: (BuildContext context, int section) {
            return SizedBox(height: 10);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 1);
          },
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 1),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    Map cellData = _sections[index.section][index.index];
    if (cellData["title"] == "用户信息") {
      return UserInfoItem(user: _loginUser);
    } else {
      String title = cellData["title"] ?? "";
      return Material(
        child: InkWell(
          child: MpsfCell(
            title: title,
          ),
          onTap: () {
            if (title == "我的博客") {
              MpsfNavigatorUtils.pushPage(
                  context: context,
                  targetPage: MpsfMyBlogsScreen(
                    blogApp: _loginUser?.blogApp,
                  ));
            } else if (title == "我的收藏") {
              MpsfNavigatorUtils.pushPage(
                  context: context, targetPage: MpsfMyCollectScreen());
            } else if (title == "浏览历史") {
              MpsfNavigatorUtils.pushPage(
                  context: context, targetPage: MpsfBrowsingHistoryScreen());
            }
          },
        ),
      );
    }
  }

  ///导航栏返回键
  List<Widget> _getAppBarActions() {
    List<Widget> actions = [];
    Widget setting = Container(
      width: getNavigationBarHeight(),
      height: double.infinity,
      child: IconButton(
        onPressed: clickSettingItem,
        icon: Icon(Icons.settings),
      ),
    );

    actions.add(setting);
    return actions;
  }

  void clickSettingItem() {
    mpsf_log("---clickSettingItem");
    MpsfNavigatorUtils.pushPage(
        context: context, targetPage: MpsfSettingScreen());
  }

  void enterWebToLogin() {
    MpsfNavigatorUtils.pushPage(
        context: context, targetPage: MpsfLoginAuthorizeScreen());
  }

  ///////////////////////////////////////////
  /// 请求
  ///////////////////////////////////////////
  void _onRefresh() async {
    await loadData();
    _refreshController.refreshCompleted();
  }

  Future<void> loadData() async {
    setState(() {
      blankStatus = MpsfBlankStatus.loading;
    });
    ApiService.fetchUserInfo().then((value) {
      if (value.success) {
        _loginUser = LoginUserBean.fromJson(value.data);
        Toast.show("获取个人信息成功", context);
      } else {
        Toast.show("获取个人信息失败", context);
      }
      blankStatus = MpsfBlankStatus.ready;
      setState(() {});
    });
  }

  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  @override
  void onFetchData() {
    loadData();
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

class UserInfoItem extends StatelessWidget {
  final LoginUserBean user;

  const UserInfoItem({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (this.user == null) {
          MpsfNavigatorUtils.pushPage(
              context: context, targetPage: MpsfLoginAuthorizeScreen());
        } else {
          
        }
      },
      child: this.user == null ? _buildWithNoLogin() : _buildWithAlreadyLogin(),
    );
  }

  Widget _buildWithAlreadyLogin() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: MpsfImageView(this.user?.avatar ?? "",
                  width: 70, height: 70)),
          Padding(padding: EdgeInsets.only(left: 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.user?.displayName ?? "displayName",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    Text(
                      this.user?.seniority ?? "seniority",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  this.user?.blogApp ?? "blogApp",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithNoLogin() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: MpsfImageView(this.user?.avatar ?? "",
                  width: 70, height: 70)),
          Padding(padding: EdgeInsets.only(left: 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "未登录",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  "点击去登陆",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
