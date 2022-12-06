import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plants_care/features/home/presentation/provider/get_plants/get_plants_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/notification_helper.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/repositories/local_plants_repository.dart';
part 'add_plant_state.dart';

final addPlantProvider = StateNotifierProvider<AddPlantProvider,AddPlantState>(
  (ref){
    final localPlantsRepo = ref.read(localPlantsRepositoryProvider);
    return AddPlantProvider(localPlantsRepo, ref);
 }
);

class AddPlantProvider extends StateNotifier<AddPlantState> {
  final LocalPlantsRepository localPlantsRepository;
  final Ref ref;
  AddPlantProvider(this.localPlantsRepository,this.ref) : super(AddPlantInitial());

  Future<void> addPlant(PlantModel plantModel) async{
    state = AddPlantLoading();

    final notificationId = await _getNotificationId();

    //if sharedPref error
    if(notificationId == -1){
      Fluttertoast.showToast(msg: 'Could not create your plant, storage problem');
      return;
    }

    plantModel.id = notificationId;

    log("notf id${plantModel.id}");

    final insertPlant = await localPlantsRepository.insertRecord(plantModel);

    insertPlant.fold(
       (failure){
          state = AddPlantError(failure.message);
        },
      (result){
          NotificationHelper.createScheduledNotification(
              plantModel.plantName??'no name',
              DateTime.fromMillisecondsSinceEpoch(plantModel.waterTime??0),
              notificationId
          );
          state = AddPlantDataFetched();

          ref.read(getPlantsProvider.notifier).getAllPlants();

        }
    );
  }

  Future<int> _getNotificationId() async {
    int? notificationId;

    try {
      notificationId = SharedPrefHelper.getInt(AppStrings.notificationIdKey);

      if (notificationId == null) {
        notificationId = 1;
      } else {
        notificationId++;
      }

      await SharedPrefHelper.addInt(AppStrings.notificationIdKey, notificationId);

    }catch(e) {
      log("from get notf id : $e");
      notificationId = -1;
    }

    return notificationId;
  }

}
