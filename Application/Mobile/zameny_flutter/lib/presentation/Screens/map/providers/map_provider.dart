import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapProvider = ChangeNotifierProvider<MapProviderNotifier>((ref) {
  return MapProviderNotifier();
});

class MapProviderNotifier extends ChangeNotifier {
  List<Floor> floors = [
    // ('url','name'),
    const Floor(
      url:'https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/uksivt.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzL3Vrc2l2dC5nbGIiLCJpYXQiOjE3MzIyMTA4MzgsImV4cCI6MTc2Mzc0NjgzOH0.vKG_JvauBJUJLuMz19mqhhIBxzipi_Nhkn-2Ddy5Aj8&t=2024-11-21T17%3A40%3A34.644Z',
      name: '1',
    ),
    // ('url','name'),
  ];
  late Floor selectedFloor; 

  MapProviderNotifier(){ 
    selectedFloor = floors.first;
  }


  void onFloorClicked(Floor floor) {
    log('message');
    selectedFloor = floor;
    notifyListeners();
  }
}

class Floor {
  final String url;
  final String name;

  const Floor({
    required this.url,
    required this.name,
  });
}