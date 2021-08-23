import 'package:get_it/get_it.dart';
import 'package:sparks/alumni/alumni_schoolinviteinput.dart';
import 'package:sparks/market/market_services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(CallService());
  locator.registerLazySingleton(() => NavigationService());
}
