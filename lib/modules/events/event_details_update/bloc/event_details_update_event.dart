part of 'event_details_update_bloc.dart';

@immutable
sealed class EventDetailsUpdateEvent {}

class UpdateEvent extends EventDetailsUpdateEvent {
  final Event event;

  UpdateEvent({required this.event});
}

class DeleteRemoteEvent extends EventDetailsUpdateEvent {
  final Event event;
  DeleteRemoteEvent({required this.event});
}
