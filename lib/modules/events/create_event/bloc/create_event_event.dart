part of 'create_event_bloc.dart';

@immutable
sealed class CreateEventEvent {}

class CreateEvent extends CreateEventEvent {
  final Event event;
  CreateEvent(this.event);
}
