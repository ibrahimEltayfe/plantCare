import 'dart:developer';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_care/core/constants/app_colors.dart';
import 'package:plants_care/core/constants/app_errors.dart';
import 'package:plants_care/core/constants/app_strings.dart';
import 'package:plants_care/core/constants/app_styles.dart';
import 'package:plants_care/core/utils/shared_pref_helper.dart';

import '../../features/reusable_components/custom_dialog.dart';

class NotificationHelper {
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
        'resource://drawable/res_notf_icon',
        [
          NotificationChannel(
            channelKey: AppStrings.basicChannel,
            channelName: 'Basic Notifications',
            channelDescription: 'Notification channel for basic',
            defaultColor:  AppColors.primaryColor,
            ledColor: AppColors.primaryColor,
            channelShowBadge: true,
            soundSource: 'resource://raw/res_notf_sound',
          ),

          NotificationChannel(
            channelKey: AppStrings.scheduledChannel,
             importance: NotificationImportance.High,
            channelName: 'Scheduled Notifications',
            channelDescription: 'Notification channel for scheduled',
            defaultColor:  AppColors.primaryColor,
            ledColor: AppColors.primaryColor,
            channelShowBadge: true,
            soundSource: 'resource://raw/res_notf_sound',
          )
        ]
    );

    //await AwesomeNotifications().resetGlobalBadge();
  }

  static checkPermission(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
          showCustomDialog(
              context: context,
              icon: Lottie.asset("assets/lottie/notification.json"),
              title: Text(
                AppStrings.notificationRequest, style: getBoldTextStyle(),),
              allowTap: () {
                Navigator.pop(context);
              },
              notAllowTap: () {
                AwesomeNotifications().requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context));
              }
          );
      }
    });
  }

  /*static Future<void> createBasicNotification(String plantName,int id) async {
    log(id.toString());
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: AppStrings.basicChannel,
          title: '${Emojis.plant_seedling}$plantName wants water ${Emojis.tool_water_pistol}',
        )
    );
  }*/

  static Future<void> createScheduledNotification(
      String plantName,
      DateTime dateTime,
      int id
   ) async {

    try{
      await AwesomeNotifications().createNotification(
          /*schedule: NotificationCalendar(
            day: dateTime.day,
            hour: dateTime.hour,
            minute: dateTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
          ),*/
        schedule: NotificationInterval(
            //todo:modify this
            interval: ((dateTime.day * 24)+(dateTime.hour*60)+(dateTime.minute*60)),
            repeats: true,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
        ),
          actionButtons: [
            NotificationActionButton(
                key: 'MARK_DONE',
                label: "Mark as done",
                actionType: ActionType.DismissAction
            )
          ],
          content: NotificationContent(
            id: id,
            channelKey: AppStrings.scheduledChannel,
            title: '${Emojis.plant_seedling}$plantName wants water ${Emojis.tool_water_pistol}',
          )
      );
    }on AwesomeNotificationsException catch(e){
      Fluttertoast.showToast(msg: 'Notification Error : ${e.message}');
    }catch(e){
      log(e.toString());
      Fluttertoast.showToast(msg: 'Notification Error..');
    }

  }

  static Future<void> cancelScheduledNotification(int id) async{
    await AwesomeNotifications().cancelSchedule(id);
  }


}