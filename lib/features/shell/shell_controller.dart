import 'package:flutter/material.dart';

/// Global tab-index notifier for [MainShell].
/// Any widget can call [ShellController.instance.value = n]
/// to switch the shell to tab [n] without pushing a new route.
final class ShellController {
  ShellController._();
  static final instance = ValueNotifier<int>(0);
}
