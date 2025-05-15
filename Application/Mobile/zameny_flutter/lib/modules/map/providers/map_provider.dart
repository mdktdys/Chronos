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
    const Floor(
      url:'https://ojbsikxdqcbuvamygezd.supabase.co/storage/v1/object/sign/zamenas/2floor.glb?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ6YW1lbmFzLzJmbG9vci5nbGIiLCJpYXQiOjE3NDczMTA4OTgsImV4cCI6MTc3ODg0Njg5OH0.XO4M_sWJNimeNZEOtLFkCuKPKlQri6p4XcoF8MdgS7I',
      name: '2',
    ),
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
