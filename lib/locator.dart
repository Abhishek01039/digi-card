import 'package:digicard/dbHelper.dart';
import 'package:digicard/view_model/cardViewModel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DBHelper());
  locator.registerLazySingleton(() => CardViewModel());

  // locator.registerLazySingleton(() => Book());
}
