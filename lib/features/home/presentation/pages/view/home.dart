import 'package:flutter/material.dart';
import 'package:plants_care/core/constants/app_colors.dart';
import 'package:plants_care/core/constants/app_strings.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';
import 'package:plants_care/features/home/presentation/reusable_components/fitted_icon.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../reusable_components/fittted_text.dart';
import '../../reusable_components/fractionally_icon.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final HomeViewModel homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
        viewModel: homeViewModel,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width*0.034),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedText(
                    height: context.height*0.1,
                    width: context.width*0.4,
                    textStyle: getBoldTextStyle(color: AppColors.primaryColor),
                    textAlign: TextAlign.start,
                    text: AppStrings.myPlants,
                ),

                _SearchBar(),

                SizedBox(height:context.height*0.04,),

                _PlantCards()


              ],
            ),
          ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width*0.92,
        height: context.height * 0.08,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: AppColors.lightGrey,
                  blurRadius: 6,
                  offset: Offset(0,context.height*0.01)
              )
            ]
        ),
        child: TextField(
          style: getRegularTextStyle(),
          decoration: InputDecoration(
              suffixIcon:const FractionallyIcon(
                widthFactor: 0.2,
                heightFactor: 0.4,
                color: AppColors.primaryColor,
                icon: AppIcons.search,
              ),

              hintText:AppStrings.searchForPlants,

              filled: false,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none
              ),
          ),
        )
    );
  }
}

class _PlantCards extends StatelessWidget {
  const _PlantCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height*0.24;

    return Expanded(
      child: ListView.separated(
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: context.height*0.03,),
        itemBuilder: (context, index) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.lightGrey,
                      blurRadius: 6,
                      offset: Offset(0,context.height*0.01)
                  )
                ]
            ),
            padding: EdgeInsets.symmetric(horizontal: context.width*0.032,vertical: context.height*0.03),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: width*0.7,
                      height: height,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //name
                          FittedText(
                            height: height*0.12,
                            width:width*0.7,
                            textAlign: TextAlign.left,
                            textStyle: getBoldTextStyle(),
                            text: 'Item Name Name ...',
                          ),

                          SizedBox(height: height*0.01,),

                          //desc
                          FittedText(
                              height: height*0.1,
                              width:width*0.7,
                              text: 'Item Place ...',
                              textAlign: TextAlign.left,
                              textStyle: getRegularTextStyle()
                          ),

                          const Spacer(),

                          //button
                          SizedBox(
                            width: width*0.3,
                            height: height*0.18,
                            child: ElevatedButton(
                                onPressed: (){},
                                style: getRegularButtonStyle(bgColor: AppColors.lightBlue, radius: 15),
                                child: LayoutBuilder(
                                    builder: (context,btnSize) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //icon
                                          Expanded(
                                            flex:1,
                                            child: Align(
                                              alignment:Alignment.centerLeft,
                                              child: FittedIcon(
                                                width: btnSize.maxWidth*0.12,
                                                height:  btnSize.maxHeight*0.7,
                                                color: AppColors.blue,
                                                icon: AppIcons.waterDrop,
                                              ),
                                            ),
                                          ),


                                          //text
                                          Expanded(
                                            flex:3,
                                            child: Align(
                                              alignment:Alignment.centerLeft,
                                              child: FittedText(
                                                width: btnSize.maxWidth*0.74,
                                                height:  btnSize.maxHeight*0.95,
                                                textStyle: getBoldTextStyle(color: AppColors.blue),
                                                text: "in 22 days",
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                )
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: width*0.005,),

                //image
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                        width: width*0.3,
                        height: height,
                        child: Placeholder()
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
