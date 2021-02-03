import 'package:flutter/material.dart';

import 'base_state.dart';

abstract class WidgetState<T extends StatefulWidget> extends BaseState<T> {
  ///刷新widget sate
  refreshState({Function task}) {
    if (mounted) {
      setState(task ?? () {});
    }
  }
}
