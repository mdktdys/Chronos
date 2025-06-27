import 'package:zameny_flutter/config/images.dart';

enum ExportScheduleType {
  current(
    'Как тут',
    null,
    Images.export,
  ),
  excel(
    'Excel',
    null,
    Images.excel,
  );

  final String title;
  final String? description;
  final String image;

  const ExportScheduleType(
    this.title,
    this.description,
    this.image,
  );
}
