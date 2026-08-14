import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the review area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => const <Object?>[];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewReady extends ReviewState {
  const ReviewReady();
}

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(const ReviewInitial());

  void start() => emit(const ReviewReady());
}
