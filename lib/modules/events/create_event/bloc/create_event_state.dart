part of 'create_event_bloc.dart';

@immutable
sealed class CreateEventState {}

final class CreateEventInitial extends CreateEventState {}

final class LoadingState extends CreateEventState {}

final class LoadedState extends CreateEventState {}

final class SuccessState extends CreateEventState {
  final Event event;

  SuccessState(this.event);
}

final class ErrorState extends CreateEventState {
  final String message;

  ErrorState(this.message);
}
