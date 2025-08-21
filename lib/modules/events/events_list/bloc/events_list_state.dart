part of 'events_list_bloc.dart';

@immutable
sealed class EventsListState {}

final class EventsListInitial extends EventsListState {}

final class EventsListLoading extends EventsListState {}

final class EventsListLoaded extends EventsListState {
  final List<Event> events;
  EventsListLoaded(this.events);
}

final class NavigateToEventDetailsPageState extends EventsListState {
  final Event event;
  NavigateToEventDetailsPageState(this.event);
}
