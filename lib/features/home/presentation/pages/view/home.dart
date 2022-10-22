import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_care/core/constants/app_colors.dart';
import 'package:plants_care/core/constants/app_strings.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/core/extensions/view_model_provider.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';
import 'package:plants_care/features/home/presentation/reusable_components/fitted_icon.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../reusable_components/fittted_text.dart';
import '../../reusable_components/fractionally_icon.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
  scrollController.addListener(() {
      context.getViewModel<HomeViewModel>().animatedSearchIconInput.add(
          scrollController.position.pixels
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width*0.034),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedText(
                      height: context.height*0.075,
                      width: context.width*0.4,
                      textStyle: getBoldTextStyle(color: AppColors.primaryColor),
                      alignment: Alignment.centerLeft,
                      text: AppStrings.myPlants,
                    ),

                     SizedBox(height:context.height*0.005,),

                    _PlantCardsList(scrollController: scrollController,)
                  ],
                ),

                StreamBuilder(
                  stream: context.getViewModel<HomeViewModel>().animatedSearchIconOutput,
                  builder: (ctx,AsyncSnapshot<double> snapshot){
                    double? val = snapshot.data;

                    if(val == null || val <= 3){
                      return const SizedBox.shrink();
                    }
                    double top = context.height*0.115 - val;
                    double right = context.height * 0.026 - val;

                    if(top <= context.height*0.027){
                      top = context.height*0.027;
                    }

                    if(right <= 0){
                      right = 0;
                    }

                    return Positioned(
                      top: top,
                      right: right,
                      child: GestureDetector(
                        onTap: () {
                            scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease
                           ).whenComplete((){
                             context.getViewModel<HomeViewModel>().searchFieldRequestFocus();
                           });
                        },
                        child: FittedIcon(
                          width: context.width*0.104,
                          height: context.height * 0.032,
                          color: AppColors.primaryColor,
                          icon: AppIcons.search,
                        ),
                      ),
                    );
                  },

                ),

                Positioned(
                  left: -context.width*0.03,
                  bottom: -context.height*0.025,
                  child: _BirdLottie()
                ),
              ]

            ),
          );
  }
}

class _BirdLottie extends StatefulWidget {
  const _BirdLottie({Key? key}) : super(key: key);

  @override
  State<_BirdLottie> createState() => _BirdLottieState();
}

class _BirdLottieState extends State<_BirdLottie> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 5)
    )..forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _animationController.reverse();
      },
      child: Lottie.asset(
          'assets/lottie/bird.json',
          reverse: true,
          repeat: false,
          controller: _animationController,
          height: context.height*0.1
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
          focusNode: context.getViewModel<HomeViewModel>().focusNode,
          decoration: InputDecoration(
            suffixIcon: StreamBuilder(
                stream: context.getViewModel<HomeViewModel>().animatedSearchIconOutput,
                builder: (context,AsyncSnapshot<double> snapshot) {
                  if(snapshot.data == null || snapshot.data! <= 3){
                    return const FractionallyIcon(
                      widthFactor: 0.2,
                      heightFactor: 0.4,
                      color: AppColors.primaryColor,
                      icon: AppIcons.search,
                    );
                  }
                  return const SizedBox.shrink();

                }
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

//plant cards listview
class _PlantCardsList extends StatelessWidget {
  final ScrollController scrollController;
  const _PlantCardsList({super.key, required this.scrollController});


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        controller: scrollController,
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: context.height*0.03,),
        itemBuilder: (context, index) {
          if(index == 0){
            return Column(
              children: [
                 SizedBox(height:context.height*0.01,),
                _SearchBar(),
                 SizedBox(height:context.height*0.026,),
                _PlantCard()
              ],
            );
          }else{
            return _PlantCard();
          }

        },
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height*0.222;

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
      padding: EdgeInsets.symmetric(horizontal: context.width*0.032,vertical: context.height*0.025),
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
                      alignment: Alignment.centerLeft,
                      textStyle: getBoldTextStyle(),
                      text: 'Item Name Name ...',
                    ),

                    SizedBox(height: height*0.012,),

                    //desc
                    FittedText(
                        height: height*0.1,
                        width:width*0.7,
                        text: 'Item Place ...',
                        alignment: Alignment.centerLeft,
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
  }
}


