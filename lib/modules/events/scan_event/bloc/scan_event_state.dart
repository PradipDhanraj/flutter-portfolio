part of 'scan_event_bloc.dart';

@immutable
sealed class ScanEventState {}

final class ScanEventInitial extends ScanEventState {}

class LoadingEvent extends ScanEventState {}

class LoadedSuccessfulEvent extends ScanEventState {
  final Event event;

  LoadedSuccessfulEvent(this.event);
}

class ErrorState extends ScanEventState {
  final String message;
  ErrorState(this.message);
}
