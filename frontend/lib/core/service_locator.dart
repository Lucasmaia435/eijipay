class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._();
  ServiceLocator._();

  final Map<Type, dynamic> _services = {};

  void registerSingleton<T>(T instance) {
    if (_services.containsKey(T)) {
      throw Exception('[Locator]: Service of type $T is already registered');
    }

    _services[T] = instance;
  }

  T get<T>() {
    return _services[T] as T;
  }
}
