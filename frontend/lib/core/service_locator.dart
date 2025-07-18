import 'package:get_it/get_it.dart';
import 'package:frontend/core/http/http_adapter.dart';
import 'package:frontend/modules/auth/repositories/auth_repository.dart';
import 'package:frontend/modules/auth/repositories/auth_repository_impl.dart';
import 'package:frontend/modules/auth/services/auth_service.dart';
import 'package:frontend/modules/funcionarios/repositories/funcionarios_repository.dart';
import 'package:frontend/modules/funcionarios/repositories/funcionarios_repository_impl.dart';
import 'package:frontend/modules/funcionarios/services/funcionarios_service.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<HttpAdapter>(() => DioHttpAdapter());

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<HttpAdapter>()));

  getIt.registerLazySingleton<FuncionariosRepository>(() => FuncionariosRepositoryImpl(getIt<HttpAdapter>()));

  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<AuthRepository>()));

  getIt.registerLazySingleton<FuncionariosService>(() => FuncionariosService(getIt<FuncionariosRepository>()));
}
