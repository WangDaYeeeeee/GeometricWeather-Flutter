// @dart=2.12

import 'package:flutter/material.dart';

const DURATION_SHORT = 1000;
const DURATION_LONG = 3000;

class SnackBarModel {

  const SnackBarModel(this.content, {
    this.action,
    this.actionCallback,
    this.dismissCallback,
    this.duration = DURATION_SHORT,
  });

  final String content;

  final String? action;
  final VoidCallback? actionCallback;
  final VoidCallback? dismissCallback;

  final int duration;
}