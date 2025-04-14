import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final pixelProvider = StateNotifierProvider<PixelNotifier, Map<Offset, Color>>((final ref) {
  return PixelNotifier();
});

class PixelNotifier extends StateNotifier<Map<Offset, Color>> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final RealtimeChannel _subscription;
  Offset? selectedCell;
  Color? selectedColor;

  PixelNotifier() : super({}) {
    _init();
  }

  Future<void> _init() async {
    await _fetchPixels();
    // _subscribeToPixels();
  }

  Future<void> _fetchPixels() async {
    final response = await supabase.from('pixels').select('x,y,color').order('id');

    state = {
      for (Map<String, dynamic> item in response)
        Offset(item['x'],item['y']): Color(int.parse(item['color'].substring(1), radix: 16) + 0xFF000000)
    };
  }

  void _subscribeToPixels() {
    _subscription = supabase.channel('pixels').onPostgresChanges(
      schema: 'public',
      table: 'pixels',
      event: PostgresChangeEvent.all,
      callback: (final PostgresChangePayload payload) {
        final Map<String, dynamic> data = payload.newRecord;
        final Map<Offset, Color> updatedState = Map<Offset, Color>.from(state);
        updatedState[Offset(data['x'],data['y'])] = Color(int.parse(data['color'].substring(1), radix: 16) + 0xFF000000);
        state = updatedState;
      }
    ).subscribe();
  }

  Future<void> placePixel(final Offset position, final double pixelSize) async {
    if (selectedColor == null) {
      return;
    }

    await supabase.from('pixels').insert({
      'x': position.dx.toInt(),
      'y': position.dy.toInt(),
      'color': '#${selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    });
  }

  @override
  void dispose() {
    _subscription.unsubscribe();
    super.dispose();
  }

  void updateSelectedCell(final Offset position, final double pixelSize) {
    selectedCell = Offset(
      (position.dx / pixelSize).floorToDouble(),
      (position.dy / pixelSize).floorToDouble()
    );

    state = Map.from(state);
  }
}
