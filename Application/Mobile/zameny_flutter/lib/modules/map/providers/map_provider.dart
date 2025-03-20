import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o3d/o3d.dart';

final mapProvider = ChangeNotifierProvider<MapProviderNotifier>((final ref) {
  return MapProviderNotifier();
});

class MapProviderNotifier extends ChangeNotifier {
  final O3DController mapController = O3DController();

  List<Floor> floors = [
    // ('url','name'),
    const Floor(
      url:'https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/uksivt3.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzL3Vrc2l2dDMuZ2xiIiwiaWF0IjoxNzMyMzc4Nzk2LCJleHAiOjE3NjM5MTQ3OTZ9.9LRQ_tT5QiVTbtOWqGZAew7JFavPe_2M4ezSMAEOqhA&t=2024-11-23T16%3A19%3A55.936Z',
      name: '2',
    ),
    // ('url','name'),
  ];
  late Floor selectedFloor; 

  MapProviderNotifier(){ 
    selectedFloor = floors.first;
  }


  void onFloorClicked(final Floor floor) {
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
