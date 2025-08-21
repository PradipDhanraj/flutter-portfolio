part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class ChangeNotificationEvent extends SettingsEvent {}
class LoadDataEvent extends SettingsEvent {}
