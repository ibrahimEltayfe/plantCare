class PlantModel{
  int? id;
  String? plantName;
  int? waterTime;

  PlantModel({required this.id, required this.plantName, required this.waterTime});

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