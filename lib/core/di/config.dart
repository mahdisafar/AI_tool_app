import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_hive.dart';

import '../../locator.dart';
import 'config.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: false,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();

  // Fallback until injectable registrations are generated correctly.
  if (!getIt.isRegistered<ClnHive>()) {
    setupLocator();
  }
}
