import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/models/models.dart';
import 'package:zameny_flutter/models/telegram_zamena_link_model.dart';

abstract class Api {
  static Future<List<Lesson>> getGroupLessons({
    required final int groupID,
    required final DateTime start,
    required final DateTime end,
  }) async {
    final List<Map<String, dynamic>> data = await GetIt.I.get<SupabaseClient>()
      .from('Paras')
      .select('id,group,number,course,teacher,cabinet,date')
      .eq('group', groupID)
      .lte('date', end.toyyyymmdd())
      .gte('date', start.toyyyymmdd());

    return data.map((final Map<String, dynamic> json) => Lesson.fromMap(json)).toList();
  }

  static Future<List<Lesson>> getCabinetLessons({
    required final int cabinetID,
    required final DateTime start,
    required final DateTime end,
  }) async {
    final List<Map<String, dynamic>> data = await GetIt.I.get<SupabaseClient>()
      .from('Paras')
      .select('id,group,number,course,teacher,cabinet,date')
      .eq('cabinet', cabinetID)
      .lte('date', end.toyyyymmdd())
      .gte('date', start.toyyyymmdd());

    return data.map((final Map<String, dynamic> json) => Lesson.fromMap(json)).toList();
  }

  static Future<List<Lesson>> loadWeekTeacherSchedule({
    required final int teacherID,
    required final DateTime start,
    required final DateTime end
  }) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client.from('Paras').select('id,group,number,course,teacher,cabinet,date').eq('teacher', teacherID).lte('date', end.toyyyymmdd()).gte('date', start.toyyyymmdd());

    final List<Lesson> weekLessons = [];
    for (final element in data) {
      final Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  static Future<List<Lesson>> loadWeekCabinetSchedule({
    required final int cabinetID,
    required final DateTime start,
    required final DateTime end
  }) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client.from('Paras').select('id,group,number,course,teacher,cabinet,date').eq('cabinet', cabinetID).lte('date', end.toyyyymmdd()).gte('date', start.toyyyymmdd());

    final List<Lesson> weekLessons = [];
    for (final element in data) {
      final Lesson lesson = Lesson.fromMap(element);
      weekLessons.add(lesson);
    }
    return weekLessons;
  }

  static Future<List<Liquidation>> getLiquidation(
    final List<int> groupsID,
    final DateTime start,
    final DateTime end,
  ) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('Liquidation')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toyyyymmdd())
        .gte('date', start.toyyyymmdd());

    return data.map((final json) => Liquidation.fromMap(json)).toList();
  }

  static Future<List<Holiday>> getHolidays(
    final DateTime start,
    final DateTime end,
  ) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('Holidays')
        .select()
        .lte('date', end.toyyyymmdd())
        .gte('date', start.toyyyymmdd());

    return data.map((final json) => Holiday.fromMap(json)).toList();
  }

  static Future<List<LessonTimings>> getTimings() async {
    final List<LessonTimings> timings = (await GetIt.I.get<SupabaseClient>().from('timings').select()).map((final json) => LessonTimings.fromMap(json)).toList();
    timings.sort(((final a, final b) => a.number - b.number));
    return timings;
  }

  static Future<List<ZamenaFull>> getZamenasFull(
    final List<int> groupsID, final DateTime start, final DateTime end,) async {

    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client
        .from('ZamenasFull')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toyyyymmdd())
        .gte('date', start.toyyyymmdd());

    return data.map((final json) => ZamenaFull.fromMap(json)).toList();
  }

  static Future<List<ZamenaFileLink>> loadZamenaFileLinksByDate({
    required final DateTime date,
  }) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .eq('date',date);

    final List<ZamenaFileLink> res = [];
    for (final element in data) {
      final ZamenaFileLink zamenaLink = ZamenaFileLink.fromMap(element);
      res.add(zamenaLink);
    }
    return res;
  }

  static Future<List<ZamenaFileLink>> getZamenaFileLinks({
    required final DateTime start,
    required final DateTime end
  }) async {
    final client = GetIt.I.get<SupabaseClient>();

    final List<dynamic> data = await client
        .from('ZamenaFileLinks')
        .select('id,link,date,created_at')
        .lte('date', end.toyyyymmdd())
        .gte('date', start.toyyyymmdd());

    return data.map((final json) => ZamenaFileLink.fromMap(json)).toList();
  }

  static Future<List<TelegramZamenaLinks>> getAlreadyFoundLinks({
    required final DateTime start,
    required final DateTime end
  }) async {
    final SupabaseClient client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client.from('AlreadyFoundsLinks').select('date,created_at').lte('date', end.toyyyymmdd()).gte('date', start.toyyyymmdd());
    return data.map((final json) => TelegramZamenaLinks.fromMap(json)).toList();
  }

  static Future<List<ZamenaFull>> getFullZamenasByDate(final DateTime date) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data =
        await client.from('ZamenasFull').select().eq('date', date);
    final List<ZamenaFull> zamenaBuffer = [];
    for (final element in data) {
      final ZamenaFull zamena = ZamenaFull.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> getZamenasByDate({
    required final DateTime date
  }) async {
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .eq('date', date.toyyyymmdd())
        .order('id',ascending: true);
    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
    }
    return zamenaBuffer;
  }

  static Future<List<Zamena>> loadZamenas({
    required final List<int> groupsID,
    required final DateTime start,
    required final DateTime end
  }) async {
    if (groupsID.isEmpty == true) {
      return [];
    }
    final client = GetIt.I.get<SupabaseClient>();
    final List<dynamic> data = await client
        .from('Zamenas')
        .select()
        .inFilter('group', groupsID)
        .lte('date', end.toyyyymmdd())
        .gte('date', start.toyyyymmdd())
        .order('date');

    final List<Zamena> zamenaBuffer = [];
    for (final element in data) {
      final Zamena zamena = Zamena.fromMap(element);
      zamenaBuffer.add(zamena);
    }

    return zamenaBuffer;
  }
}
