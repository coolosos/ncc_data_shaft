part of 'ncc_connection_driver.dart';

/// {@template http_data_shaft_driver}
/// A specialized [NccConnectionDriver] that utilizes the standard [NccClient].
///
/// This driver is intended for standard HTTP communication where session
/// persistence or specialized authentication headers (managed by a SessionClient)
/// are not the primary requirement, or are handled manually.
/// {@endtemplate}
base class HttpDataShaftDriver extends NccConnectionDriver<NccClient> {
  /// {@macro http_data_shaft_driver}
  ///
  /// Requires an instance of [NccClient] to delegate network requests.
  ///
  /// ### Example:
  /// ```dart
  /// final nccClient = NccClient();
  /// final driver = HttpDataShaftDriver(client: nccClient);
  /// ```
  HttpDataShaftDriver({required super.client});
}
