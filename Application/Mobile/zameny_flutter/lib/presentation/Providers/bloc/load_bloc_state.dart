part of 'load_bloc_bloc.dart';

sealed class LoadBlocState {}

final class LoadBlocInitial extends LoadBlocState {}
final class LoadBlocLoading extends LoadBlocState {}
final class LoadBlocLoaded extends LoadBlocState {}
final class LoadBlocFailed extends LoadBlocState {}
