import 'package:zameny_flutter/config/extensions/datetime_extension.dart';
import 'package:zameny_flutter/core/model.dart';

class ZamenaFullFilter extends Filter {
  int? id;
  List<int>? group;
  DateTime? startDate;
  DateTime? endDate;

  ZamenaFullFilter({
    this.id,
    this.group,
    this.startDate,
    this.endDate,
  });

  List<MapEntry<String, String>> toQueryParams() {
    final params = <MapEntry<String, String>>[];

    if (id != null) {
      params.add(MapEntry('id', id.toString()));
    } 

    if (group != null) {
      for (final g in group!) {
        params.add(MapEntry('group', g.toString()));
      }
    }

    if (startDate != null) {
      params.add(MapEntry('start_date', startDate!.toyyyymmdd()));
    } 

    if (endDate != null) {
      params.add(MapEntry('end_date', endDate!.toyyyymmdd()));
    } 

    return params;
  }
}
