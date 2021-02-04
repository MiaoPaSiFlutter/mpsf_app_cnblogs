
import 'package:flutter/material.dart';

import 'full_screen_loading_dialog.dart';

@optionalTypeArgs
mixin FullScreenDialogMixin<T extends StatefulWidget> on State<T> {
  ///在页面上方显示一个 loading widget
  ///共有两种方法，showProgressDialog是其中一种
  ///具体参见 : progress_widget.dart
  ///如果需要在 [dismissProgressDialog] 方法后跳转到其他页面或者执行什么
  ///使用 参数 [afterDismiss]
  DialogLoadingController _dialogLoadingController;
  showProgressDialog({
    Widget progress,
    Color bgColor,
    Function afterDismiss,
  }) {
    if (_dialogLoadingController == null) {
      _dialogLoadingController = DialogLoadingController();
      Navigator.of(context)
          .push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 0),
          opaque: false,
          pageBuilder: (ctx, animation, secondAnimation) {
            return FullScreenLoadingDialog(
              controller: _dialogLoadingController,
              progress: progress,
              bgColor: bgColor,
            );
          },
        ),
      )
          .then((value) {
        _dialogLoadingController = null;
        if (afterDismiss != null) {
          afterDismiss();
        }
      });
    }
  }

  dismissProgressDialog() {
    _dialogLoadingController?.dismissDialog();
  }

  @override
  void dispose() {
    _dialogLoadingController = null;
    super.dispose();
  }
}