import 'package:get_it/get_it.dart';

import 'data_service.dart';
import 'web_data_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<DataService>(() => WebDataService());
}
