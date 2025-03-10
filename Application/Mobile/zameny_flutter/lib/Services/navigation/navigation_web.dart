
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';

import 'package:web/web.dart';

class Navigation extends ChangeNotifier{
  String currentPath = '';

  Future<void> setPath(final String path) async {
    currentPath = path;
    window.history.replaceState(null, '', path);
  }

  Future<void> setParams(final Map<String, dynamic> params) async {
    // window.history.replaceState(null, '', '$currentPath?test=123');
    final String query = queryBuilder(params);
    window.history.replaceState(null, '', '$currentPath?$query');
  }

  Future<void> clearParams() async {
    
  }

  String queryBuilder(final Map<String, dynamic> query) {
    return query.entries.map((final e) => "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}").join('&');
  }
}
