


import 'package:get_it/get_it.dart';
import 'package:muhasebetest/app/services/DBService.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => DBService());
}
