part of 'events_list_bloc.dart';

@immutable
sealed class EventsListEvent {}

class InitialEventsListEvent extends EventsListEvent {}

class LaunchMapEvent extends EventsListEvent {
  final double latitude;
  final double longitude;

  LaunchMapEvent(this.latitude, this.longitude);
}

class AddNewEvent extends EventsListEvent {
  final Event event;
  AddNewEvent(this.event);
}

class RefreshList extends EventsListEvent {}

class NavigateToEventDetailsPage extends EventsListEvent {
  final Event event;
  NavigateToEventDetailsPage(this.event);
}

class UpdateEvent extends EventsListEvent {
  final Event event;
  UpdateEvent(this.event);
}

class DeleteLocalEvent extends EventsListEvent {
  final Event event;
  DeleteLocalEvent(this.event);
}

class BroadcastMessageEvent extends EventsListEvent {
  final String body;
  final String title;
  final String topic;
  final dynamic data;
  BroadcastMessageEvent(this.topic, this.title, this.body, {this.data});

  Map<String, dynamic> toJson() {
    return {'topic': topic, 'title': title, 'body': body, 'data': data ?? {}};
  }
}
