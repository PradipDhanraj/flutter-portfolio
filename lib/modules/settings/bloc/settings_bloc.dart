// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myevents/services/authentication/auth_service.dart';
import 'package:myevents/services/permissions/permissions_service.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';
import 'package:myevents/utility/shared_prefs/shared_prefs.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPrefs _prefs;
  final PermissionsService _permissionsService;
  final AuthService authService;
  bool get isUsedLoggedIn => authService.isUserLoggedin;
  bool get notificationsEnabled =>
      _prefs.getBool(PrefsKeys.notificationEnabled) ?? false;

  SettingsBloc(this._prefs, this._permissionsService, this.authService)
    : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {});
    on<LoadDataEvent>((event, emit) async {
      emit(SettingsInitial());
    });
    on<ChangeNotificationEvent>((event, emit) async {
      if (!await _permissionsService.isNotificationPermissionGranted()) {
        await _permissionsService.requestNotificationPermission();
      }
      if (await _permissionsService.isNotificationPermissionGranted()) {
        if (_prefs.getBool(PrefsKeys.notificationEnabled) == true) {
          await _prefs.setBool(PrefsKeys.notificationEnabled, false);
          emit(SettingsInitial());
        } else {
          await _prefs.setBool(PrefsKeys.notificationEnabled, true);
          emit(SettingsInitial());
        }
      } else {
        emit(SettingsInitial());
      }
    });
  }
}
