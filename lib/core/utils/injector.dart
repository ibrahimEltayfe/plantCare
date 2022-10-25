import 'package:get_it/get_it.dart';
import 'package:plants_care/features/home/data/data_sources/local_data_source.dart';
import 'package:plants_care/features/home/domain/repositories/local_db_repository.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';

import '../../features/home/data/repositories/local_plants_repository_impl.dart';

final injector = GetIt.instance;

void init(){
  injector.registerFactory<HomeViewModel>(() => HomeViewModel(injector()));

  injector.registerLazySingleton<LocalDataSource>(() => LocalDataSource());
  injector.registerLazySingleton<LocalPlantsRepository>(() => LocalPlantsRepositoryImpl(injector()));

}