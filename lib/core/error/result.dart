import 'app_failure.dart';

/// The return shape of any operation that can fail across a layer boundary.
///
/// Sealed on purpose: the caller cannot ignore the failure case, so a failure
/// never reaches the UI as an unhandled exception (Principle III).
sealed class Result<T> {
  const Result();

  /// True when this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// The value if successful, otherwise null.
  T? get valueOrNull => switch (this) {
    Success<T>(value: final T v) => v,
    FailureResult<T>() => null,
  };

  /// The failure if unsuccessful, otherwise null.
  AppFailure? get failureOrNull => switch (this) {
    Success<T>() => null,
    FailureResult<T>(failure: final AppFailure f) => f,
  };
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final AppFailure failure;
}
