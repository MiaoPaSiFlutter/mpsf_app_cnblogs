import 'package:flutter/material.dart';
import 'package:mpsf_app/common/screen/widget_state.dart';

class FullScreenLoadingDialog extends StatefulWidget {
  final Widget progress;
  final Color bgColor;
  //final LoadingCreate loadingCreate;
  final DialogLoadingController controller;
  FullScreenLoadingDialog({
    Key key,
    this.progress,
    this.bgColor,
    this.controller,
  }) : super(key: key);

  @override
  _FullScreenLoadingDialogState createState() =>
      _FullScreenLoadingDialogState();
}

class _FullScreenLoadingDialogState
    extends WidgetState<FullScreenLoadingDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.isShow) {
        //todo
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.isShow = false;
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      child: Container(
        color: widget.bgColor ?? Color.fromRGBO(34, 34, 34, 0.3),
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: widget.progress ?? CircularProgressIndicator(),
      ),
      onWillPop: () async {
        widget.controller.dismissDialog();
        return false;
      },
    );
  }
}

class DialogLoadingController extends ChangeNotifier {
  bool isShow = true;
  dismissDialog() {
    if (isShow) {
      isShow = false;
      notifyListeners();
    }
  }
}


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