import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/events_list/repository/event_repository.dart';
import 'package:myevents/utility/locator.dart';
part 'events_list_event.dart';
part 'events_list_state.dart';

class EventsListBloc extends Bloc<EventsListEvent, EventsListState> {
  final EventListRepository eventListRepository;

  EventsListBloc(this.eventListRepository) : super(EventsListInitial()) {
    on<EventsListEvent>((event, emit) {});
    on<LaunchMapEvent>((event, emit) {
      final latitude = event.latitude;
      final longitude = event.longitude;
      eventListRepository.openMap(latitude, longitude);
    });
    on<InitialEventsListEvent>((event, emit) async {
      emit(EventsListLoading());
      final events = await eventListRepository.fetchAllLocalEvents();
      emit(EventsListLoaded(events));
    });
    on<RefreshList>((event, emit) async {
      emit(EventsListLoading());
      await eventListRepository.refreshList();
      //await Future.delayed(Duration(seconds: 3));
      add(InitialEventsListEvent());
    });
    on<AddNewEvent>((event, emit) async {
      await eventListRepository.addNewEvent(event.event);
      add(InitialEventsListEvent());
    });
    on<NavigateToEventDetailsPage>((event, emit) async {
      emit(NavigateToEventDetailsPageState(event.event));
    });
    on<UpdateEvent>((event, emit) async {
      await eventListRepository.updateEvent(event.event);
      add(InitialEventsListEvent());
    });
    on<DeleteLocalEvent>((event, emit) async {
      await eventListRepository.deleteLocalEvent(event.event);
      add(InitialEventsListEvent());
    });
    on<BroadcastMessageEvent>((event, emit) async {
      if (DI.authService.isUserLoggedin) {
        eventListRepository.broadcastMessage(event.toJson());
      }
    });
  }
}
