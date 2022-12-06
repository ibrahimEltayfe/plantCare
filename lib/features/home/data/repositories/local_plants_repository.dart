import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:plants_care/core/error/exception_handler.dart';
import 'package:plants_care/features/home/data/data_sources/local_data_source.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../core/error/failures.dart';
import '../models/plant_model.dart';

final localPlantsRepositoryProvider = Provider<LocalPlantsRepository>((ref) {
  final localDataSource = ref.read(localDataSourceProvider);
  return LocalPlantsRepository(localDataSource);
});

class LocalPlantsRepository{
  final LocalDataSource localDataSource;
  LocalPlantsRepository(this.localDataSource);

  Future<Either<Failure,int>> deleteRecord(String id) {
    return _handleFailures<int>(() async{
      return await localDataSource.deleteRecord(id);
    });
  }

  Future<Either<Failure,int>> insertRecord(PlantModel plantModel) async{
    return _handleFailures<int>(() async{
      return await localDataSource.insertToDB(plantModel);
    });
  }

  Future<Either<Failure,int>> updateRecord(PlantModel plantModel) {
    return _handleFailures<int>(() async{
       return await localDataSource.updateDB(plantModel);
    });
  }

  Future<Either<Failure,List<PlantModel>>> getAllRecords() async{
    return _handleFailures<List<PlantModel>>(() async{
      final List<Map<String,dynamic>> list = await localDataSource.getAllRecords();
      return list.map((e) => PlantModel.fromJson(e)).toList();
    });

  }

  Future<Either<Failure,T>> _handleFailures<T>(Future Function() task) async{
    try{
      final T result = await task();
      return Right(result);
    }catch(error){
      log("from repo:$error");
      return Left(ExceptionHandler.handle(error).failure);
    }

  }

}

