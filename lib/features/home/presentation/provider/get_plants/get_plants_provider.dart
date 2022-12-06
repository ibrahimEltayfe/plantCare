import 'package:riverpod/riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/repositories/local_plants_repository.dart';
part 'get_plants_state.dart';

final getPlantsProvider = StateNotifierProvider<GetPlantsProvider,GetPlantsState>(
  (ref){
    final localPlantsRepo = ref.read(localPlantsRepositoryProvider);
    return GetPlantsProvider(localPlantsRepo);
  }
);

class GetPlantsProvider extends StateNotifier<GetPlantsState> {
  final LocalPlantsRepository localPlantsRepository;
  GetPlantsProvider(this.localPlantsRepository) : super(GetPlantsInitial());

  Future<void> getAllPlants() async{
    state = GetPlantsLoading();

    final insertPlant = await localPlantsRepository.getAllRecords();

    insertPlant.fold(
        (failure){
          state = GetPlantsError(failure.message);
        },
         (plants){
          state = GetPlantsDataFetched(plants);
        }
    );
  }
}



