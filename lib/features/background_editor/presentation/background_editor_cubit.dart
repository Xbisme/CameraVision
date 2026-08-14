import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal state for the background_editor area.
///
/// Spec #001 ships this area as a placeholder; the state exists to prove the
/// slice is wired end to end. Real behaviour arrives in a later spec.
sealed class BackgroundEditorState extends Equatable {
  const BackgroundEditorState();

  @override
  List<Object?> get props => const <Object?>[];
}

class BackgroundEditorInitial extends BackgroundEditorState {
  const BackgroundEditorInitial();
}

class BackgroundEditorReady extends BackgroundEditorState {
  const BackgroundEditorReady();
}

class BackgroundEditorCubit extends Cubit<BackgroundEditorState> {
  BackgroundEditorCubit() : super(const BackgroundEditorInitial());

  void start() => emit(const BackgroundEditorReady());
}
