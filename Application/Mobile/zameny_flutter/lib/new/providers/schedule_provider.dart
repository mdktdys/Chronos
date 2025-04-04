import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import 'package:zameny_flutter/config/enums/schedule_view_modes.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/groups_provider.dart';
import 'package:zameny_flutter/new/sharing/sharing.dart';

final scheduleSettingsProvider = ChangeNotifierProvider<ScheduleSettingsNotifier>((final ref) {
  return ScheduleSettingsNotifier(ref: ref);
});
class ScheduleSettingsNotifier extends ChangeNotifier {
  Ref ref;
  ScreenshotController screenShotController = ScreenshotController();
  ScheduleViewModes viewmode = ScheduleViewModes.auto;
  bool isShowZamena = true;
  bool obed = false;

  ScheduleSettingsNotifier({required this.ref});

  Future<void> export() async {
    final Uint8List? image = await screenShotController.capture();

    if (image == null) {
      return;
    }

    ref.read(sharingProvier).shareFile(text: 'Расписание', files: [image]);
  }

  void notify() {
    notifyListeners();
  }
}

final searchItemProvider = StateNotifierProvider<SearchItemNotifier, SearchItem?>((final Ref ref) {
  return SearchItemNotifier(ref: ref);
});

class SearchItemNotifier extends StateNotifier<SearchItem?> {
  bool isLoading = false;
  final Ref ref;

  SearchItemNotifier({required this.ref}): super(null);
  
  Future<void> getSearchItem({
    required final int id,
    required final int type
  }) async {
    isLoading = true;

    await ref.watch(futureSearchItemProvider((
      id: id,
      type: type
    )).future);

    isLoading = false;
  }

  void setState(final SearchItem? value) {
    state = value;
  }
}

final navigationDateProvider = StateNotifierProvider<NavigationDateNotifier, DateTime>(
  (final ref) => NavigationDateNotifier(),
);

class NavigationDateNotifier extends StateNotifier<DateTime> {
  NavigationDateNotifier() : super(_initializeDate());

  void toggleWeek(final int days) {
    state = state.add(Duration(days: days));
  }

  static DateTime _initializeDate() {
    final DateTime date = DateTime.now();
    if (date.weekday == 7) {
      return date.add(const Duration(days: 1));
    }
    return date;
  }
}
