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

class MpsfMyBlogsScreen extends StatefulWidget {
  //博客名
  final String blogApp;
  MpsfMyBlogsScreen({Key key, this.blogApp}) : super(key: key);

  @override
  _MpsfMyBlogsScreenState createState() => _MpsfMyBlogsScreenState();
}

class _MpsfMyBlogsScreenState extends State<MpsfMyBlogsScreen>
    with MpsfCommonFunction {
  List _items = [];
  int _page = 1;
  dynamic _blogAppInfo; //个人博客信息

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的博客'),
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
          Map model = _items[index] as Map;
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

    if (_blogAppInfo == null) {
      ApiResultData respM =
          await ApiService.fetchBlogApp(blogApp: widget.blogApp);
      _blogAppInfo = respM.data;
    }

    ApiService.fetchBlogApp(blogApp: widget.blogApp, page: _page).then((respM) {
      _refreshController.refreshCompleted();

      if (_page == 1) {
        _items.clear();
      }
      if (respM.data != null) {
        _items.addAll(respM.data);
      }

      if (_blogAppInfo != null) {
        int pageSize = _blogAppInfo["pageSize"];
        if (_page > pageSize) {
          _refreshController.loadNoData();
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
    onFetchData();
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
            _buildDescription(context),
            _buildTool(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Text(this.data["Title"] ?? "",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333))),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        this.data["Description"] ?? "",
        maxLines: 2,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333)),
      ),
    );
  }

  Widget _buildTool(BuildContext context) {
    String avatar = this.data["Avatar"];
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                MpsfImageView(avatar, width: 30, height: 30),
                Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  this.data["Author"] ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  RelativeDateFormat.getTimeLine(
                      context, this.data["PostDate"] ?? ""),
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "评论：${this.data["CommentCount"]}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
