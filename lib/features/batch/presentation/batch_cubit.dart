import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the batch area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class BatchState extends Equatable {
  const BatchState();

  @override
  List<Object?> get props => const <Object?>[];
}

class BatchInitial extends BatchState {
  const BatchInitial();
}

class BatchReady extends BatchState {
  const BatchReady();
}

class BatchCubit extends Cubit<BatchState> {
  BatchCubit() : super(const BatchInitial());

  void start() => emit(const BatchReady());
}
