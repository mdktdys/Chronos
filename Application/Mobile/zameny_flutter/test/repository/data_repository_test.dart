import 'package:test/test.dart';

import 'package:zameny_flutter/new/repository/fastapi_repository.dart';
import 'package:zameny_flutter/new/repository/reposiory.dart';
import 'package:zameny_flutter/new/repository/supabase_repository.dart';

void main() {
  test('Test FastAPI', () async {
    final DataRepository repository = FastAPIDataRepository();
    final Stopwatch stopwatch = Stopwatch()..start();

    await repository.getGroups();

    stopwatch.stop();
    print('FastAPI getGroups() executed in ${stopwatch.elapsedMilliseconds} ms');

    expect(true, true);
  });

  test('Test Supabase', () async {
    final DataRepository repository = SupabaseDataRepository();
    final Stopwatch stopwatch = Stopwatch()..start();

    await repository.getGroups();

    stopwatch.stop();
    print('Supabase getGroups() executed in ${stopwatch.elapsedMilliseconds} ms');

    expect(true, true);
  });
}
