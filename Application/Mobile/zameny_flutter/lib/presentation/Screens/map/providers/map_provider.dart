import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapProvider = ChangeNotifierProvider<MapProviderNotifier>((ref) {
  return MapProviderNotifier();
});

class MapProviderNotifier extends ChangeNotifier {
  List<(String,String)> floors = [
    // ('url','name'),
    ('https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/uksivt.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzL3Vrc2l2dC5nbGIiLCJpYXQiOjE3MzIyMTA4MzgsImV4cCI6MTc2Mzc0NjgzOH0.vKG_JvauBJUJLuMz19mqhhIBxzipi_Nhkn-2Ddy5Aj8&t=2024-11-21T17%3A40%3A34.644Z','1'),
    ('https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/uksivt.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzL3Vrc2l2dC5nbGIiLCJpYXQiOjE3MzIyMTA4MzgsImV4cCI6MTc2Mzc0NjgzOH0.vKG_JvauBJUJLuMz19mqhhIBxzipi_Nhkn-2Ddy5Aj8&t=2024-11-21T17%3A40%3A34.644Z','2'),
    ('https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/uksivt.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzL3Vrc2l2dC5nbGIiLCJpYXQiOjE3MzIyMTA4MzgsImV4cCI6MTc2Mzc0NjgzOH0.vKG_JvauBJUJLuMz19mqhhIBxzipi_Nhkn-2Ddy5Aj8&t=2024-11-21T17%3A40%3A34.644Z','3'),
    // ('url','name'),
  ];
  late (String, String) selectedFloor; 

  MapProviderNotifier(){
    selectedFloor = floors.first;
  }


  void onFloorClicked((String,String) floor) {
    log('message');
    selectedFloor = floor;
    notifyListeners();
  }
}