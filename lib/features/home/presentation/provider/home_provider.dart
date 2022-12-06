import 'dart:async';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:plants_care/features/home/presentation/provider/get_plants/get_plants_provider.dart';
import '../../../../core/constants/app_strings.dart';

final homeProvider = Provider<HomeProvider>((ref) {
  return HomeProvider(ref);
});

class HomeProvider{
  final Ref ref;
  HomeProvider(this.ref);

  final StreamController<double> animatedSearchIconController = StreamController<double>.broadcast();

  void init(){
    animatedSearchIconInput.add(0);
  }

  void dispose(){
    animatedSearchIconController.close();
  }

  void handleNotifications(){
    /* Future.wait([
     AwesomeNotifications().cancelAllSchedules(),

    ]);*/
    AwesomeNotifications().setListeners(
      onNotificationDisplayedMethod: (receivedNotification) async{
        await ref.read(getPlantsProvider.notifier).getAllPlants();
      },
      onActionReceivedMethod: (receivedAction) async{
        await AwesomeNotifications().setGlobalBadgeCounter(0);
      },
      onDismissActionReceivedMethod: (receivedAction) async{
        await AwesomeNotifications().setGlobalBadgeCounter(0);
      },
    );

  }
  Future<String> getWaterTimeDuration(int plantId) async{

    final notfList = await AwesomeNotifications().listScheduledNotifications();

    if (notfList.isEmpty) {
      return AppStrings.needWater;
    }

    NotificationModel? notfModel;
    for(NotificationModel element in notfList){
      if(element.content!.id == plantId){
        notfModel = element;
        break;
      }
    }

    if(notfModel==null){
      return AppStrings.needWater;
    }

    final currentDateTime = DateTime.now();
    final schedule = notfModel.schedule!.toMap();
    final notfDateTime = DateTime(
        schedule["year"],
        schedule["month"],
        schedule["day"],
        schedule["hour"],
        schedule["minute"]
    );

    final duration = notfDateTime.difference(currentDateTime);

    log("in " +duration.inMinutes.toString());

    String text = "in ";

    if(duration.inDays > 0){

      if(duration.inDays == 1){
        text += "${duration.inDays} day, ${duration.inHours-(duration.inDays*24)} hour";
      }else{
        text += "${duration.inDays} days, ${duration.inHours-(duration.inDays*24)} hour";
      }

    }else if(duration.inHours > 0){

      if(duration.inHours == 1){
        text += "${duration.inHours} hour, ${duration.inMinutes-(duration.inHours*60)} minute";
      }else{
        text += "${duration.inHours} hours, ${duration.inMinutes-(duration.inHours*60)} minute";
      }

    }else if(duration.inMinutes > 0 || duration.inSeconds > 0){

      if(duration.inMinutes == 1){
        text += "${duration.inMinutes} minute";
      }else if(duration.inMinutes > 0){
        text += "${duration.inMinutes} minutes";
      }else if(duration.inSeconds > 0){
        text = "less than minute";
      }

    }else{
       text = AppStrings.needWater;
    }

    return text;
  }

  //inputs
  Sink get animatedSearchIconInput => animatedSearchIconController.sink;

  //outputs
  Stream<double> get animatedSearchIconOutput => animatedSearchIconController.stream;

}