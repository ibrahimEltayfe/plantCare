part of 'get_plants_provider.dart';

abstract class GetPlantsState extends Equatable {
  const GetPlantsState();

  @override
  List<Object> get props => [];
}

class GetPlantsInitial extends GetPlantsState {}

class GetPlantsLoading extends GetPlantsState {}

class GetPlantsDataFetched extends GetPlantsState {
  final List<PlantModel> plants;
  const GetPlantsDataFetched(this.plants);

  @override
  List<Object> get props => [plants];
}

class GetPlantsError extends GetPlantsState {
  final String message;
  const GetPlantsError(this.message);

  @override
  List<Object> get props => [message];
}