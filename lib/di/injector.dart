import 'package:exachanger_app/shared/local/cache/local_db.dart';
import 'package:exachanger_app/shared/local/cache/local_db_impl.dart';
import 'package:exachanger_app/shared/local/shared_prefs/shared_pref.dart';
import 'package:exachanger_app/shared/local/shared_prefs/shared_pref_impl.dart';
import 'package:exachanger_app/shared/network/dio_network_service.dart';
import 'package:exachanger_app/shared/network/network_service.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

Future<void> initSingletons() async {
  //Services
  injector.registerLazySingleton<LocalDb>(() => InitDbImpl());
  injector.registerLazySingleton<NetworkService>(() => DioNetworkService());
  injector.registerLazySingleton<SharedPref>(() => SharedPrefImplementation());

  //initiating db
  await injector<LocalDb>().initDb();
}

void provideDataSources() {
  //Home
  // injector.registerFactory<HomeLocalDataSource>(
  //     () => HomeLocalDataSourceImpl(localDb: injector.get<LocalDb>()));
  // injector.registerFactory<HomeRemoteDataSource>(() =>
  //     HomeRemoteDataSourceImpl(networkService: injector.get<NetworkService>()));
}

void provideRepositories() {
  //home
  // injector.registerFactory<HomeRepository>(
  //   () => HomeRepositoryImpl(
  //     homeRemoteDataSource: injector.get<HomeRemoteDataSource>(),
  //     homeLocalDataSource: injector.get<HomeLocalDataSource>(),
  //   ),
  // );
}

void provideUseCases() {
  //home
  // injector.registerFactory<FetchAndCacheGenreUseCase>(
  //   () => FetchAndCacheGenreUseCase(
  //     homeRepository: injector.get<HomeRepository>(),
  //   ),
  // );
}
