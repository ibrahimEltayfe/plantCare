import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plants_care/features/base/base_view_model.dart';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:plants_care/features/home/domain/repositories/local_db_repository.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/utils/notification_helper.dart';
import '../../../../../core/utils/shared_pref_helper.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs,HomeViewModelOutputs{
  final LocalPlantsRepository localPlantsRepository;
  HomeViewModel(this.localPlantsRepository);

  FocusNode focusNode = FocusNode();
  StreamController<double> animatedSearchIconController = StreamController.broadcast();
  StreamController<FocusNode> searchFieldFocusNodeController = StreamController();

  //public functions
  @override
  void start() {
    animatedSearchIconInput.add(0.0);
    searchFieldFocusNodeInput.add(focusNode);
  }

  @override
  void dispose() {
    animatedSearchIconController.close();
    searchFieldFocusNodeController.close();
  }

  void searchFieldRequestFocus(){
    focusNode.requestFocus();
  }

  Future<void> addPlant(PlantModel plantModel) async{

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
              //set notification
              NotificationHelper.createScheduledNotification(
                  plantModel.plantName??'plant name',
                  DateTime.fromMillisecondsSinceEpoch(plantModel.waterTime??0),
                  notificationId
              );
              log(result.toString());
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
  //outputs
  @override
  Stream<double> get animatedSearchIconOutput => animatedSearchIconController.stream;

  @override
  Stream<FocusNode> get searchFieldFocusNodeOutput => searchFieldFocusNodeController.stream;

}

abstract class HomeViewModelInputs{
  Sink<double> get animatedSearchIconInput;
  Sink<FocusNode> get searchFieldFocusNodeInput;
}

abstract class HomeViewModelOutputs{
  Stream<double> get animatedSearchIconOutput;
  Stream<FocusNode> get searchFieldFocusNodeOutput;
}