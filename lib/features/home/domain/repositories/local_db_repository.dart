import 'package:dartz/dartz.dart';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:plants_care/features/home/domain/entities/plant_entity.dart';
import '../../../../core/error/failures.dart';

abstract class LocalPlantsRepository{
  Future<Either<Failure,int>> insertRecord(PlantModel plantModel);
  Future<Either<Failure,int>> updateRecord(PlantEntity plantEntity);
  Future<Either<Failure,int>> deleteRecord(String id);
  Future<Either<Failure,List<PlantEntity>>> getAllRecords();
}