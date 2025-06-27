enum ScheduleViewMode {
  schedule(name: 'Расписание'),
  standart(name: 'Без замен'),
  zamenas(name: 'Только замены');

  const ScheduleViewMode({required this.name});

  final String name;
}
