part of 'event_details_update_bloc.dart';

@immutable
sealed class EventDetailsUpdateState {}

final class EventDetailsUpdateInitial extends EventDetailsUpdateState {}

final class LoadingState extends EventDetailsUpdateState {}

final class LoadedState extends EventDetailsUpdateState {}

final class DeletedRemoteEventState extends EventDetailsUpdateState {}
final class EventDetailsUpdateStatus extends EventDetailsUpdateState {
  final String message;
  final bool status;
  final Event? event;
  EventDetailsUpdateStatus(this.status, this.message, [this.event]);
}
