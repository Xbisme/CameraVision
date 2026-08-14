import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the settings area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => const <Object?>[];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsReady extends SettingsState {
  const SettingsReady();
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsInitial());

  void start() => emit(const SettingsReady());
}
