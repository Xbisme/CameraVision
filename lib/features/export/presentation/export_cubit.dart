import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the export area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object?> get props => const <Object?>[];
}

class ExportInitial extends ExportState {
  const ExportInitial();
}

class ExportReady extends ExportState {
  const ExportReady();
}

class ExportCubit extends Cubit<ExportState> {
  ExportCubit() : super(const ExportInitial());

  void start() => emit(const ExportReady());
}
