part of 'add_plant_provider.dart';

abstract class AddPlantState extends Equatable {
  const AddPlantState();

  @override
  List<Object> get props => [];
}

class AddPlantInitial extends AddPlantState {}

class AddPlantLoading extends AddPlantState {}

class AddPlantDataFetched extends AddPlantState {}

class AddPlantError extends AddPlantState {
  final String message;
  const AddPlantError(this.message);

  @override
  List<Object> get props => [message];
}