import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/core/extensions/view_model_provider.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:plants_care/features/home/domain/entities/plant_entity.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';
import 'package:plants_care/features/reusable_components/fittted_text.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/app_styles.dart';
import '../../../../../../core/utils/notification_helper.dart';
import 'input_text_field.dart';

class BottomSheetContent extends StatefulWidget {
  final HomeViewModel homeViewModel;
  const BottomSheetContent({super.key, required this.homeViewModel});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController plantNameController;
  late TextEditingController dayController;
  late TextEditingController hourController;
  late TextEditingController minuteController;

  @override
  void initState() {
    plantNameController = TextEditingController();
    dayController = TextEditingController();
    hourController = TextEditingController();
    minuteController = TextEditingController();
    widget.homeViewModel.addPlantLoadingInput.add(false);
    super.initState();
  }

  @override
  void dispose() {
    plantNameController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: context.height*0.44,
        width: context.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.width*0.05),
                topRight: Radius.circular(context.width*0.05)
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: context.height*0.034,),
              InputTextField(
                  controller:plantNameController,
                  hint: AppStrings.plantName,
                  textInputAction: TextInputAction.next,
                  icon: FontAwesomeIcons.seedling,
                  activeColor: AppColors.primaryColor,
                  validator: (value){
                    if(value == null || value.trim() == "") {
                      return "Value can not be empty";
                    }

                    return null;
                  },
              ),

              SizedBox(height: context.height*0.045,),
              const BuildTextHeader(text: AppStrings.remindMeAfter,),

              SizedBox(height: context.height*0.02,),
              _BuildReminderTimeFields(
                dayController:dayController,
                hourController:hourController,
                minuteController:minuteController,
              ),

              SizedBox(height: context.height*0.045,),
              _AddPlantButton(
                homeViewModel: widget.homeViewModel,
                onTap: () async{
                  if(formKey.currentState!.validate()){

                    final DateTime waterTime = DateTime.now().add(
                      Duration(
                        days: int.parse(dayController.text) ,
                        hours: int.parse(hourController.text),
                        minutes: int.parse(minuteController.text)
                      )
                    );

                    PlantModel plantModel = PlantModel(
                        id: 0,
                        plantName: plantNameController.text,
                        waterTime: waterTime.millisecondsSinceEpoch
                    );

                    await widget.homeViewModel.addPlant(plantModel);

                  }
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

/* Add Plant Button */
class _AddPlantButton extends StatelessWidget {
  final VoidCallback onTap;
  final HomeViewModel homeViewModel;
  const _AddPlantButton({Key? key, required this.onTap, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width*0.45,
      height: context.height*0.08,
      child: ElevatedButton(
          style: getRegularButtonStyle(bgColor: AppColors.primaryColor, radius: 15),
          onPressed: onTap,
          child: StreamBuilder(
            stream: homeViewModel.addPlantLoadingOutput,
            builder: (context, snapshot) {
              log(snapshot.data.toString());
              if(snapshot.data == null || snapshot.data == true){
                return const Center(child: CircularProgressIndicator(color: AppColors.white,));
              }
                return FittedText(
                  width: context.width*0.26,
                  height: context.height*0.06,
                  textStyle: getBoldTextStyle(color: AppColors.white),
                  text: AppStrings.addPlant,
                );

            },
          )
      ),
    );
  }
}

/* Text Header */
class BuildTextHeader extends StatelessWidget {
  final String text;
  const BuildTextHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: context.width*0.05),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          text,
          style: getBoldTextStyle(color: AppColors.black),
        ),
      ),
    );
  }
}

/* Reminder Time Text Fields */
class _BuildReminderTimeFields extends StatelessWidget {
  final TextEditingController dayController;
  final TextEditingController hourController;
  final TextEditingController minuteController;
  const _BuildReminderTimeFields({Key? key, required this.dayController, required this.hourController, required this.minuteController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: context.width*0.92,
      height: context.height*0.075,
      child: Row(
        children: [
          Expanded(
            child: InputTextField(
              controller: dayController,
              hint: AppStrings.day,
              textInputAction: TextInputAction.done,
              activeColor: AppColors.primaryColor,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value == null || value.trim() == "") {
                  return "Value can not be empty";
                }

                  return null;
              },
            ),
          ),

          SizedBox(width: context.width*0.065,),

          Expanded(
            child: InputTextField(
              controller: hourController,
              hint: AppStrings.hour,
              textInputAction: TextInputAction.done,
              activeColor: AppColors.primaryColor,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value == null || value.trim() == "") {
                  return "Value can not be empty";
                }

                return null;
              },
            ),
          ),

          SizedBox(width: context.width*0.065,),

          Expanded(
            child: InputTextField(
              controller: minuteController,
              hint: AppStrings.minute,
              textInputAction: TextInputAction.done,
              activeColor: AppColors.primaryColor,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              validator: (value){
                if(value == null || value.trim() == "") {
                  return "Value can not be empty";
                }

                if(int.parse(value) <= 0
                    && int.parse(dayController.text) <= 0
                    && int.parse(hourController.text) <= 0
                ){
                  return 'error';
                }

                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
