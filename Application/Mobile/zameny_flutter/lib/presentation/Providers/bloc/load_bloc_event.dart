part of 'load_bloc_bloc.dart';

@immutable
sealed class LoadBlocEvent {}

final class OnLoaded extends LoadBlocEvent{}
final class OnLoading extends LoadBlocEvent{}
final class OnFailedLoading extends LoadBlocEvent{}
final class OnInitial extends LoadBlocEvent{}