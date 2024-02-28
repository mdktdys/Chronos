import 'package:bloc/bloc.dart';

part 'load_bloc_event.dart';
part 'load_bloc_state.dart';

class LoadBloc extends Bloc<LoadBlocEvent, LoadBlocState> {
  LoadBloc() : super(LoadBlocInitial()) {
    on<OnInitial>((event, emit) {

    });
  }
}
