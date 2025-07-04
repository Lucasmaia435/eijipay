import 'package:frontend/core/service_locator.dart';

abstract class Binding {
  void dependencies(ServiceLocator locator);
}
