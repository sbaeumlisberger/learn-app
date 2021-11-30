import 'package:learn_app/src/persistence_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Registers services to be used in the app. Must be called before accessing services via getIt.
setupServiceLocator() async {
  getIt.registerSingleton<PersistenceService>(PersistenceService());
  await getIt<PersistenceService>().init(); // wait for initialization of persistence service

  // Add new services here
}
