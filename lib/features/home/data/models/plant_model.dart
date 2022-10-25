import 'package:plants_care/features/home/domain/entities/plant_entity.dart';

class PlantModel extends PlantEntity{
  PlantModel({required super.id, required super.plantName, required super.waterTime});

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'plantName' : plantName,
      'waterTime' : waterTime,
    };
  }

  factory PlantModel.fromJson(Map<String,dynamic> data){
    return PlantModel(
      id: data['id'],
      plantName:data['plantName'],
      waterTime: data['waterTime'],
    );
  }
}