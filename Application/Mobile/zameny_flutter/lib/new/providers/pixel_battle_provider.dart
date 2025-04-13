import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final pixelProvider = StateNotifierProvider<PixelNotifier, Map<String, Color>>((final ref) {
  return PixelNotifier();
});

class PixelNotifier extends StateNotifier<Map<String, Color>> {
  PixelNotifier() : super({}) {
    _init();
  }

  final SupabaseClient supabase = Supabase.instance.client;
  late final RealtimeChannel _subscription;
  Offset? selectedCell;
  Color? selectedColor;

  Future<void> _init() async {
    await _fetchPixels();
    _subscribeToPixels();
  }

  Future<void> _fetchPixels() async {
    final response = await supabase.from('pixels').select();

    state = {
      for (var item in response)
        '${item['x']}_${item['y']}': Color(_hexToColor(item['color']))
    };
  }

  void updateSelectedCell(final Offset position, final double pixelSize) {
    final x = (position.dx / pixelSize).floor();
    final y = (position.dy / pixelSize).floor();
    selectedCell = Offset(x.toDouble(), y.toDouble());

    state = Map.from(state);
  }

  void _subscribeToPixels() {
    _subscription = supabase.channel('pixels').onPostgresChanges(
      schema: 'public',
      table: 'pixels',
      event: PostgresChangeEvent.all,
      callback: (final PostgresChangePayload payload) {
        log(payload.toString());
        final Map<String, dynamic> data = payload.newRecord;
        final updatedState = Map<String, Color>.from(state);
        updatedState['${data['x']}_${data['y']}'] = Color(_hexToColor(data['color']));
        state = updatedState;
      }
    ).subscribe();
  }

  Future<void> placePixel(final Offset position, final double pixelSize) async {
    // final x = (position.dx / pixelSize).floor();
    // final y = (position.dy / pixelSize).floor();

    if (selectedColor == null) {
      return;
    }

    await supabase.from('pixels').insert({
      'x': position.dx.toInt(),
      'y': position.dy.toInt(),
      'color': _colorToHex(selectedColor!),
    });

    // final updatedState = Map<String, Color>.from(state);
    // updatedState['${x}_$y'] = selectedColor;
    // state = updatedState;
  }

  int _hexToColor(final String hex) {
    return int.parse(hex.substring(1), radix: 16) + 0xFF000000;
  }

  String _colorToHex(final Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  void dispose() {
    _subscription.unsubscribe();
    super.dispose();
  }
}
