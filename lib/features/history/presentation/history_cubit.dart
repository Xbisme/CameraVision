import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the history area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => const <Object?>[];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryReady extends HistoryState {
  const HistoryReady();
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryInitial());

  void start() => emit(const HistoryReady());
}
