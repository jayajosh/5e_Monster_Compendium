import 'package:get_it/get_it.dart';
import 'package:monster_compendium/services/navigation.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => Navigation());
}