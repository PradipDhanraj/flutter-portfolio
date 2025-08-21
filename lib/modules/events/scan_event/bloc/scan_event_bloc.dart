// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myevents/modules/events/events_list/repository/event_model.dart';
import 'package:myevents/modules/events/scan_event/repository/scan_repository.dart';
import 'package:myevents/services/notification/notification_service.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';
import 'package:myevents/utility/utils/extensions.dart';

part 'scan_event_event.dart';
part 'scan_event_state.dart';

class ScanEventBloc extends Bloc<ScanEventEvent, ScanEventState> {
  final ScanRepository _scanRepository;
  final SharedPrefs _prefs;

  ScanEventBloc(this._scanRepository, this._prefs) : super(ScanEventInitial()) {
    on<ScanEventEvent>((event, emit) {});
    on<CreateEvent>((event, emit) async {
      try {
        emit(LoadingEvent());
        var eventObj = await _scanRepository.getEventDetailsById(event.code);
        var list = await _prefs.addNewEvent(eventObj);
        if (list.any((element) => element.event_id == event.code)) {
          await eventObj.changeNotificationSubscriptionStatus(true);
          NotificationService.subscribeToTopic(event.code);
        }
        emit(LoadedSuccessfulEvent(eventObj));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
