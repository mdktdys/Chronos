
import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/new/notapi.dart';
import 'package:zameny_flutter/shared/domain/models/models.dart';

part 'zamena_provider.freezed.dart';
part 'zamena_provider.g.dart';

final panelExpandedProvider = StateProvider<bool>((final ref) {
  return false;
});

@freezed
sealed class ZamenaScreenState with _$ZamenaScreenState {
  factory ZamenaScreenState({
    required final DateTime currentDate,
    required final ZamenaViewType view,
    required final DateTimeRange visibleDateRange,
  }) = _ZamenaScreenState;
}

@riverpod
class ZamenaScreen extends _$ZamenaScreen {
  final PageController pageController = PageController(initialPage: 1000);
  final DateRangePickerController monthController = DateRangePickerController();

  @override
  ZamenaScreenState build() {
    final DateTime now = DateTime.now();
    final visibleRange = DateTimeRange(
      start: now.toStartOfWeek(),
      end: now.toEndOfWeek(),
    );

    Future.microtask(() {
      ref.read(zamenaDataLoaderProvider.notifier).loadIfNotCached(visibleRange);
    });

    return ZamenaScreenState(
      currentDate: now,
      view: ZamenaViewType.group,
      visibleDateRange: visibleRange,
    );
  }

  void setDate(final DateTime date) {
    state = state.copyWith(currentDate: date);
  }

  void toggleWeek(final int days) {
    DateTime newDate = state.currentDate.add(Duration(days: days));
    if (newDate.weekday == 7) {
      newDate = newDate.add(Duration(days: days));
    }
    state = state.copyWith(currentDate: newDate);
  }

  void changeView(final ZamenaViewType view) {
    state = state.copyWith(view: view);
  }

  void setVisibleDateRange(final DateTimeRange range) {
    state = state.copyWith(visibleDateRange: range);
    ref.read(zamenaDataLoaderProvider.notifier).loadIfNotCached(range);
  }
}

enum ZamenaViewType {
  teacher,
  group
}

final zamenasListProvider = AsyncNotifierProvider<ZamenasNotifier, (List<Zamena>,List<ZamenaFull>)>((){
  return ZamenasNotifier();
});

class ZamenasNotifier extends AsyncNotifier<(List<Zamena>,List<ZamenaFull>)> {

  @override
  FutureOr<(List<Zamena>,List<ZamenaFull>)> build() async {
    final DateTime date = ref.watch(zamenaScreenProvider.select((final state) => state.currentDate));
    try {
      final result = await Future.wait([
        Api.getZamenasByDate(date: date),
        Api.getFullZamenasByDate(date),
        Api.loadZamenaFileLinksByDate(date: date),
      ].toList());
      return (result[0] as List<Zamena>,result[1] as List<ZamenaFull>);
    } catch (e) {
      return (List<Zamena>.empty(),List<ZamenaFull>.empty());
    }
  }

  static (List<Zamena>,List<ZamenaFull>) fake() {
    final math.Random random = math.Random();
    final DateTime date = DateTime.now();

    final List<Zamena> zamena = List.generate(random.nextInt(6), (final int index) {
      return Zamena.mock(
        date: date,
        timing: index,
      );
    });

    return (
      zamena,
      []
    );
  }
}

class DateRangeCache {
  final List<DateTimeRange> _loadedRanges = [];

  bool isCovered(final DateTimeRange newRange) {
    return _loadedRanges.any((final cached) =>
      !newRange.start.isBefore(cached.start) &&
      !newRange.end.isAfter(cached.end));
  }

  void add(final DateTimeRange newRange) {
    _loadedRanges.add(newRange);
  }
}

@riverpod
class ZamenaDataLoader extends _$ZamenaDataLoader {
  final DateRangeCache _cache = DateRangeCache();

  @override
  List<ZamenaFileLink> build() {
    return [];
  }

  Future<void> loadIfNotCached(final DateTimeRange range) async {
    if (_cache.isCovered(range)) {
      return;
    }

    final newLinks = await _load(range);
    _cache.add(range);

    final updated = {...state, ...newLinks}.toList();
    state = updated;
  }

  Future<List<ZamenaFileLink>> _load(final DateTimeRange range) async {
    final result = await Api.loadZamenaFileLinksByDateRange(date: range);
    return result;
  }
}
