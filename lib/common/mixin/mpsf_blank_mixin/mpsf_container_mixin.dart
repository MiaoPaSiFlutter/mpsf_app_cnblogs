import 'package:flutter/material.dart';

import 'mpsf_body_container.dart';
import 'mpsf_container_info.dart';

@optionalTypeArgs
mixin MpsfContainerMixin<T extends StatefulWidget> on State<T> {
  ///[空置页面]
  int containerStatus = 0;
  MpsfContainerInfo containerInfo = MpsfContainerInfo();

  Widget buildMpsfContainer() {
    return MpsfBodyContainer(
      containerInfo: containerInfo,
      onTapBlank: onTapBlank,
      bodyWidget: buildBodyWidget(),
    );
  }

  Widget buildBodyWidget() {
    return Container();
  }

  void onTapBlank() {}

  void setContainerStatus(int status) {
    setState(() {
      containerInfo.status = status;
    });
  }
}
