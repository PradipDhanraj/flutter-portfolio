part of 'scan_event_bloc.dart';

@immutable
sealed class ScanEventEvent {}

class ScanEvent {
  final String code;
  ScanEvent(this.code);
}

class CreateEvent extends ScanEventEvent{
  final String code;
  CreateEvent(this.code);
}
class ErrorEvent extends ScanEventEvent {
  final String message;

  ErrorEvent(this.message);
}
