import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widget_state.dart';








///显示progress 方式 2
///这种方式，不需要在布局中添加

//typedef LoadingCreate = void Function(DialogLoadingController controller);

/// 加载弹窗 [showProgressDialog] (页面)的 [RouteSettings].name
/// * 某些情况，可能需要当前route的名字，故这里标记上。
final String loadingLayerRouteName = 'LoadingProgressState';

class LoadingProgressState extends WidgetState {
  final Widget progress;
  final Color bgColor;
  //final LoadingCreate loadingCreate;
  final DialogLoadingController controller;

  LoadingProgressState({this.progress, this.bgColor, this.controller});

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.isShow) {
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
    controller.isShow = false;
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
        child: Container(
          color: bgColor ?? Color.fromRGBO(34, 34, 34, 0.3),
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: progress ?? CircularProgressIndicator(),
        ),
        onWillPop: () async {
          controller.dismissDialog();
          return false;
        });
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
