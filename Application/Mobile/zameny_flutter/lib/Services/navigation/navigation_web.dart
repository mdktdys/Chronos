
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';

class Navigation extends ChangeNotifier{
  String currentPath = '';

  Future<void> setPath(final String path) async {
    currentPath = path;
    html.window.history.replaceState(null, '', path);
  }

  Future<void> setParams(final Map<String, dynamic> params) async {
    // html.window.history.replaceState(html.window.history.state, '', currentPath);
  }
}
