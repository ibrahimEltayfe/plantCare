import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:plants_care/core/constants/app_errors.dart';
import 'package:plants_care/core/error/exception_handler.dart';
import 'package:plants_care/features/home/data/data_sources/local_data_source.dart';
import 'package:plants_care/features/home/domain/entities/plant_entity.dart';
import 'package:plants_care/features/home/domain/repositories/local_db_repository.dart';
import '../../../../core/error/failures.dart';
import '../models/plant_model.dart';

class LocalPlantsRepositoryImpl extends LocalPlantsRepository{
  final LocalDataSource localDataSource;
  LocalPlantsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure,int>> deleteRecord(String id) {
    return _handleFailures<int>(() async{
      return await localDataSource.deleteRecord(id);
    });
  }

  @override
  Future<Either<Failure,int>> insertRecord(PlantModel plantModel) async{
    return _handleFailures<int>(() async{
      return await localDataSource.insertToDB(plantModel);
    });
  }

  @override
  Future<Either<Failure,int>> updateRecord(PlantEntity plantEntity) {
    return _handleFailures<int>(() async{
       return await localDataSource.updateDB(plantEntity);
    });
  }

  @override
  Future<Either<Failure,List<PlantEntity>>> getAllRecords() async{
    return _handleFailures<List<PlantEntity>>(() async{
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

