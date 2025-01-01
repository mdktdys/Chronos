import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as river;
import 'package:zameny_flutter/shared/providers/schedule_provider.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc() : super(ExportReady()) {
    on<ExportStart>((final event, final emit) async {
      try {
        emit(ExportLoading());
        await event.ref.read(scheduleProvider).exportSchedulePNG(event.context, event.ref);
        emit(ExportReady());
      } catch (error) {
        emit(ExportFailed(reason: error.toString()));
      }
    });
  }
}

abstract class ExportEvent {}

class ExportStart extends ExportEvent {
  final BuildContext context;
  final river.WidgetRef ref;
  ExportStart({required this.context, required this.ref});
}

abstract class ExportState {}

class ExportReady extends ExportState {}

class ExportFailed extends ExportState {
  final String reason;
  ExportFailed({required this.reason});
}

class ExportLoading extends ExportState {}
