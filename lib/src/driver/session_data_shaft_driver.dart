part of 'ncc_connection_driver.dart';

/// {@template session_data_shaft_driver}
/// A specialized [NccConnectionDriver] that utilizes the [SessionClient] from `ncc`.
///
/// This driver is designed for authenticated communication. It leverages `ncc`'s
/// session management capabilities—such as automatic token injection,
/// session persistence, and synchronized headers—while providing the
/// [RemoteDriver] interface required by `data_shaft` repositories.
/// {@endtemplate}
base class SessionDataShaftDriver extends NccConnectionDriver<SessionClient> {
  /// {@macro session_data_shaft_driver}
  ///
  /// Takes a [SessionClient] which typically manages the user's
  /// authentication state and persistent headers.
  ///
  /// ### Example:
  /// ```dart
  /// final sessionClient = SessionClient();
  /// // The driver will now use the authenticated session for all requests
  /// final driver = SessionDataShaftDriver(client: sessionClient);
  /// ```
  SessionDataShaftDriver({required super.client});
}
