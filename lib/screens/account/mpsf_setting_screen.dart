import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpsf_app/common/manager/mpsf_navigator_utils.dart';
import 'package:mpsf_app/common/mixin/mpsf_blank_mixin/mpsf_container_mixin.dart';
import 'package:mpsf_app/common/widgets/cell/mpsf_cell.dart';
import 'package:mpsf_app/screens/login/mpsf_login_screen.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';

import 'mpsf_setting_vm.dart';

class MpsfSettingScreen extends StatefulWidget {
  MpsfSettingScreen({Key key}) : super(key: key);

  @override
  _MpsfSettingScreenState createState() => _MpsfSettingScreenState();
}

class _MpsfSettingScreenState extends State<MpsfSettingScreen>
    with WidgetsBindingObserver, MpsfPageMixin, MpsfContainerMixin {
  MpsfSettingVM pageVM = MpsfSettingVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        leading: getBackItem(),
      ),
      body: buildMpsfContainer(),
    );
  }

  ///////////////////////////////////////////
  /// BodyWidget
  ///////////////////////////////////////////
  Widget buildBodyWidget() {
    return Container(
      height: double.infinity,
      color: Theme.of(context).dividerColor,
      child: GroupListView(
        padding: EdgeInsets.all(0),
        sectionsCount: pageVM.sections.length,
        countOfItemInSection: (int section) {
          return pageVM.sections[section].length;
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
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    Map cellData = pageVM.sections[index.section][index.index];
    if (cellData["title"] == "退出") {
      return Material(
        child: InkWell(
          child: Container(
            width: double.infinity,
            height: 44,
            child: Center(
              child: Text(
                cellData["title"],
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          onTap: () {},
        ),
      );
    } else {
      String title = cellData["title"] ?? "";
      return Material(
        child: InkWell(
          child: MpsfCell(
            title: title,
          ),
          onTap: () {
            if (title == "账号管理") {
              MpsfNavigatorUtils.pushPage(
                  context: context, targetPage: MpsfLoginScreen());
            } else if (title == "账号与安全") {}
          },
        ),
      );
    }
  }

  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  ///////////////////////////////////////////
  @override
  void onFetchData() {
    // TODO: implement onFetchData
  }
}
