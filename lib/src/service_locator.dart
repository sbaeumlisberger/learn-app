import 'package:learn_app/src/persistence_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerSingleton<PersistenceService>(PersistenceService());
}
