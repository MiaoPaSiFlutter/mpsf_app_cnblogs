import 'package:flutter/material.dart';

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
    extends State<FullScreenLoadingDialog> {
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

