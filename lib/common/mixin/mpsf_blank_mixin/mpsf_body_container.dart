import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mpsf_package_common/mpsf_package_common.dart';
import 'mpsf_container_info.dart';

class MpsfBodyContainer extends StatefulWidget {
  final MpsfContainerInfo containerInfo;
  final Widget bodyWidget;
  final VoidCallback onTapBlank;
  MpsfBodyContainer({
    Key key,
    this.containerInfo,
    this.bodyWidget,
    this.onTapBlank,
  }) : super(key: key);

  @override
  _MpsfBodyContainerState createState() => _MpsfBodyContainerState();
}

class _MpsfBodyContainerState extends State<MpsfBodyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          widget.bodyWidget,
          InkWell(
            child: _buildBlank(),
            onTap: widget.onTapBlank,
          )
        ],
      ),
    );
  }

  Widget _buildBlank() {
    if (widget.containerInfo.status == MCIStatus.ready) {
      return Container(width: 0, height: 0);
    } else if (widget.containerInfo.status == MCIStatus.loading) {
      String filepath = "assets/lottiefiles/material_wave_loading.json";
      return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black12),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            child: Lottie.asset(filepath),
          ),
        ),
      );
    } else if (widget.containerInfo.status == MCIStatus.noData) {
      return MpsfBlankWidget(
        containerInfo: this.widget.containerInfo,
      );
    } else if (widget.containerInfo.status == MCIStatus.error) {
      return MpsfBlankWidget(
        containerInfo: this.widget.containerInfo,
      );
    }
    return Container(width: 0, height: 0);
  }
}

class MpsfBlankWidget extends StatelessWidget {
  final MpsfContainerInfo containerInfo;

  const MpsfBlankWidget({
    Key key,
    this.containerInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int status = this.containerInfo.status;
    String blankIconPath;
    String blankTitle;

    if (status == MCIStatus.noData) {
      blankIconPath =
          this.containerInfo.blankIconPath ?? "userful_images/ic_error_empty";
      blankTitle = this.containerInfo.blankTitle ?? "暂无数据";
    } else if (status == MCIStatus.error) {
      blankIconPath =
          this.containerInfo.blankIconPath ?? "userful_images/ic_error_network";
      blankTitle = this.containerInfo.blankTitle ?? "请求失败";
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              child: MpsfImageView(blankIconPath),
            ),
            SizedBox(height: 15),
            Container(
              child: Text(
                blankTitle,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
