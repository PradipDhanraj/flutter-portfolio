// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myevents/modules/events/event_details_update/repository/event_details_update_repository.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';

part 'event_details_update_event.dart';
part 'event_details_update_state.dart';

class EventDetailsUpdateBloc
    extends Bloc<EventDetailsUpdateEvent, EventDetailsUpdateState> {
  final EventDetailsUpdateRepository eventDetailsUpdateRepository;
  EventDetailsUpdateBloc(this.eventDetailsUpdateRepository)
    : super(EventDetailsUpdateInitial()) {
    on<EventDetailsUpdateEvent>((event, emit) {});
    on<DeleteRemoteEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await eventDetailsUpdateRepository.deleteRemoteEvent(event.event);
        emit(DeletedRemoteEventState());
      } catch (e) {
        emit(EventDetailsUpdateStatus(false, e.toString(), null));
      } finally {
        emit(LoadedState());
      }
    });
    on<UpdateEvent>((event, emit) async {
      emit(LoadingState());
      try {
        var result = await eventDetailsUpdateRepository.updateEvent(
          event.event,
        );
        await Future.delayed(const Duration(seconds: 2));
        emit(
          EventDetailsUpdateStatus(true, 'Event updated successfully.', result),
        );
      } catch (e) {
        emit(EventDetailsUpdateStatus(false, e.toString(), null));
      } finally {
        emit(LoadedState());
      }
    });
  }
}
