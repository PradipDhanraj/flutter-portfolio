import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myevents/modules/authentication/repository/auth_repo.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final AuthRepo authRepo;

  CreateEventBloc(this.authRepo) : super(CreateEventInitial()) {
    on<CreateEventEvent>((event, emit) {});
    on<CreateEvent>((event, emit) async {
      try {
        emit(LoadingState());
        if (!authRepo.authService.isUserLoggedin) {
          await authRepo.authService.signInWithGoogle();
          if (!authRepo.authService.isUserLoggedin) {
            throw Exception('User is not logged in');
          }
        }
        var newEvent = await authRepo.createEvent(event.event);
        await Future.delayed(Duration(seconds: 2));
        emit(SuccessState(newEvent));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
