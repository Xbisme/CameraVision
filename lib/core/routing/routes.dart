/// Route paths, per `specs/001-project-foundation/contracts/routes.md`.
///
/// String literals at call sites are forbidden (Principle X) — navigate with
/// these constants.
abstract final class AppRoutes {
  /// The launch route. Nothing precedes it: no onboarding, no gate (FR-021).
  static const String cameraCapture = '/';

  static const String review = '/review';
  static const String backgroundEditor = '/editor';
  static const String batch = '/batch';
  static const String export = '/export';
  static const String history = '/history';
  static const String settings = '/settings';

  /// Development-only navigation index.
  ///
  /// Registered by the development composition root ONLY. The production
  /// binary never references it, so its absence is structural rather than a
  /// runtime check (FR-018, FR-022).
  static const String developerIndex = '/dev';
}
