library toast;

import 'dart:async';

import 'package:flutter/material.dart';

part 'widgets/main_box.dart';

class Toast {
  final BuildContext context;

  Toast({required this.context});

  static Toast of(BuildContext context) => Toast(context: context);

  info([String? msg]) {
    _createEntry(_ToastType.info, msg: msg);
  }

  success([String? msg]) {
    _createEntry(_ToastType.success, msg: msg);
  }

  error([String? msg]) {
    _createEntry(_ToastType.error, msg: msg);
  }

  loading([String? msg]) {
    _createEntry(_ToastType.loading, msg: msg);
  }

  remove() {
    if (_MainBox.entry != null && _MainBox.entry!.mounted) {
      _MainBox.entry!.remove();
      _MainBox.entry = null;
    }
  }

  _createEntry(_ToastType type, {String? msg}) {
    if (_MainBox.entry != null && _MainBox.entry!.mounted) {
      _MainBox.entry!.remove();
      _MainBox.entry = null;
    }

    _MainBox.entry = OverlayEntry(
        builder: (_) => _MainBox(
              type: type,
              msg: msg,
            ));

    Overlay.of(context)?.insert(_MainBox.entry!);
  }
}

extension AppendSpaceToListAndRemoveNull<K> on List<K> {
  /// 移除空项和添加空隙
  List<T> appendSpaceAndRemoveNull<T>(T space) {
    return whereType<T>()
        .expand((element) sync* {
          yield space;
          yield element;
        })
        .skip(1)
        .toList();
  }

  /// 仅移除空项
  List<T> removeNull<T>() {
    return whereType<T>().toList();
  }

  /// 仅添加空隙
  List<K> appendSpace(K space) {
    return expand((element) sync* {
      yield space;
      yield element;
    }).skip(1).toList();
  }
}
