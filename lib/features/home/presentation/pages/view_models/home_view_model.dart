import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plants_care/features/base/base_view_model.dart';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:plants_care/features/home/domain/repositories/local_db_repository.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/notification_helper.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../domain/entities/plant_entity.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs,HomeViewModelOutputs{
  final LocalPlantsRepository localPlantsRepository;
  HomeViewModel(this.localPlantsRepository);

  FocusNode focusNode = FocusNode();
  StreamController<double> animatedSearchIconController = StreamController.broadcast();
  StreamController<FocusNode> searchFieldFocusNodeController = StreamController();
  StreamController<List<PlantEntity>> plantsController = StreamController();
  StreamController<bool> addPlantLoadingController = StreamController.broadcast();

  //public functions
  @override
  void start() {
    animatedSearchIconInput.add(0.0);
    searchFieldFocusNodeInput.add(focusNode);
    plantsController.add([]);
    addPlantLoadingController.add(false);
  }

  @override
  void dispose() {
    animatedSearchIconController.close();
    searchFieldFocusNodeController.close();
    plantsController.close();
    addPlantLoadingController.close();
  }

  void searchFieldRequestFocus(){
    focusNode.requestFocus();
  }

  Future<void> addPlant(PlantModel plantModel) async{
    addPlantLoadingInput.add(true);

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
              log("From failure");
              Fluttertoast.showToast(msg: failure.message);
            },
            (result){
              NotificationHelper.createScheduledNotification(
                  plantModel.plantName??'no name',
                  DateTime.fromMillisecondsSinceEpoch(plantModel.waterTime??0),
                  notificationId
              );
              getAllPlants();
              Fluttertoast.showToast(
                  msg: AppStrings.plantAdded,
                  backgroundColor: AppColors.green,
                  textColor: AppColors.white,

              );

            }
    );
    addPlantLoadingInput.add(false);

  }

  Future<void> getAllPlants() async{

    final insertPlant = await localPlantsRepository.getAllRecords();

    insertPlant.fold(
       (failure){
          log("From getPlants failure");

          plantsController.addError(failure.message);
        },
       (result){
          plantsInput.add(result);
        }
    );
  }

  //private functions
  static Future<int> _getNotificationId() async {
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

  //inputs
  @override
  Sink<double> get animatedSearchIconInput => animatedSearchIconController.sink;

  @override
  Sink<FocusNode> get searchFieldFocusNodeInput => searchFieldFocusNodeController.sink;

  @override
  Sink<List<PlantEntity>> get plantsInput => plantsController.sink;

  @override
  Sink<bool> get addPlantLoadingInput => addPlantLoadingController.sink;

  //outputs
  @override
  Stream<double> get animatedSearchIconOutput => animatedSearchIconController.stream;

  @override
  Stream<FocusNode> get searchFieldFocusNodeOutput => searchFieldFocusNodeController.stream;

  @override
  Stream<List<PlantEntity>> get plantsOutput => plantsController.stream;

  @override
  Stream<bool> get addPlantLoadingOutput => addPlantLoadingController.stream;

}

abstract class HomeViewModelInputs{
  Sink<double> get animatedSearchIconInput;
  Sink<FocusNode> get searchFieldFocusNodeInput;
  Sink<List<PlantEntity>> get plantsInput;
  Sink<bool> get addPlantLoadingInput;

}

abstract class HomeViewModelOutputs{
  Stream<double> get animatedSearchIconOutput;
  Stream<FocusNode> get searchFieldFocusNodeOutput;
  Stream<List<PlantEntity>> get plantsOutput;
  Stream<bool> get addPlantLoadingOutput;

}