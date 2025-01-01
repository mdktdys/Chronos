
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';

class Navigation extends ChangeNotifier{
  Future<void> setPath(final String path) async {
    html.window.history.replaceState(null, '', path);
  }
}
