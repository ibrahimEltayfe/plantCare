import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_care/core/constants/app_colors.dart';
import 'package:plants_care/core/constants/app_strings.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/features/home/domain/entities/plant_entity.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../reusable_components/fitted_icon.dart';
import '../../../../reusable_components/fittted_text.dart';
import '../../../../reusable_components/fractionally_icon.dart';
import '../../../../reusable_components/fractionally_text.dart';

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

    /*Future.wait([
     AwesomeNotifications().cancelAllSchedules(),

    ]);*/
    AwesomeNotifications().setListeners(
      onNotificationDisplayedMethod: (receivedNotification) async{
        await context.read<HomeViewModel>().getAllPlants();
      },
      onActionReceivedMethod: (receivedAction) async{
        await AwesomeNotifications().setGlobalBadgeCounter(0);
      },
      onDismissActionReceivedMethod: (receivedAction) async{
        await AwesomeNotifications().setGlobalBadgeCounter(0);
      },
    );

    //scroll to searchBar
    scrollController.addListener(() {
      if(scrollController.position.pixels > context.height*0.102){
        return;
      }
      context.read<HomeViewModel>().animatedSearchIconInput.add(
          scrollController.position.pixels
      );
      });


    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    context.read<HomeViewModel>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width*0.034),
            child: Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.height*0.01,),
                    ),
                    SliverPersistentHeader(
                        pinned: true,
                        delegate:PersistenceHeader(context.height*0.085)
                    ),

                    SliverAppBar(
                      floating: false,
                      pinned: false,
                      backgroundColor: AppColors.bgColor,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(context.height*0.05),
                        child: SizedBox(
                          width: context.width*0.92,
                          height: context.height * 0.115,
                          child: Column(
                            children: [
                              SizedBox(height:context.height*0.01,),
                              _SearchBar(),
                              SizedBox(height:context.height*0.025,),
                            ],
                          ),
                        ),
                      ) ,

                    ),
                    

                    _PlantCardsList(scrollController: scrollController),
                  ],
                ),

                _ParallaxSearchIcon(scrollController: scrollController,),

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


class _ParallaxSearchIcon extends StatelessWidget {
  final ScrollController scrollController;
  const _ParallaxSearchIcon({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<HomeViewModel>().animatedSearchIconOutput,
      builder: (ctx,AsyncSnapshot<double> snapshot){
        double? val = snapshot.data;

        if(val == null || val <= 3){
          return const SizedBox.shrink();
        }
        double top = context.height*0.129 - val;
        double right = context.height * 0.025 - val;

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
                context.read<HomeViewModel>().searchFieldRequestFocus();
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

    );
  }
}

class PersistenceHeader extends SliverPersistentHeaderDelegate{
  final double extent;
  const PersistenceHeader(this.extent, {Key? key});

  @override
  Widget build(BuildContext context ,double shrinkOffset, bool overlapsContent) {
    return Container(
        color: AppColors.bgColor,
        height: extent,
        width: context.width,
        child: FractionallyText(
          widthFactor: 0.5,
          heightFactor: 0.88,
          textStyle: getBoldTextStyle(color: AppColors.primaryColor),
          text: AppStrings.myPlants,
        )

    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
            textInputAction: TextInputAction.done,
            expands: true,
            maxLines: null,
            style: getRegularTextStyle(),
            focusNode: context.read<HomeViewModel>().focusNode,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              suffixIcon: StreamBuilder(
                  stream: context.read<HomeViewModel>().animatedSearchIconOutput,
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
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final PlantEntity plant;
  const _PlantCard({Key? key, required this.plant}) : super(key: key);

  Future<String> _getWaterTimeDuration() async{

    final notfList = await AwesomeNotifications().listScheduledNotifications();

    if (notfList.isEmpty) {
      return AppStrings.needWater;
    }

    NotificationModel? notfModel;
    for(NotificationModel element in notfList){
      if(element.content!.id == plant.id){
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

    log("in minutes " +duration.inMinutes.toString());
    log("in minutes " +duration.inHours.toString());
    log("in minutes " +duration.inDays.toString());


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
     // text = AppStrings.needWater;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height*0.222;

    return Padding(
      padding: EdgeInsets.only(bottom: context.height*0.03),
      child: Container(
        width: width,

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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
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
                          Text(
                            plant.plantName ?? "...",
                            style: getBoldTextStyle(
                                fontSize: context.height*0.022
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: height*0.012,),

                          //desc
                          /*FittedText(
                              height: height*0.1,
                              width:width*0.7,
                              text: 'Item Place ...',
                              alignment: Alignment.centerLeft,
                              textStyle: getRegularTextStyle()
                          ),*/

                          const Spacer(),

                          //button
                          SizedBox(
                            width: width*0.39,
                            height: height*0.19,
                            child: FutureBuilder(
                              future: _getWaterTimeDuration(),
                              builder: (context, duration) {
                                String? text = duration.data;
                                bool needWater = false;
                                log(text.toString());

                                if(text == null){
                                  text = "...";
                                }else if(duration.data == AppStrings.needWater){
                                  text = "need water";
                                  needWater = true;
                                }

                                return ElevatedButton(
                                    onPressed: (){},
                                    style: getRegularButtonStyle(
                                        bgColor:needWater?AppColors.lightRed:AppColors.lightBlue,
                                        radius: 15
                                    ),
                                    child: LayoutBuilder(
                                        builder: (context,btnSize) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  //icon
                                                  Expanded(
                                                    flex:0,
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

                                                  SizedBox(width: btnSize.maxWidth*0.05,),

                                                  //text
                                                  Expanded(
                                                      flex:1,
                                                      child: FittedText(
                                                        width: btnSize.maxWidth*0.74,
                                                        height: btnSize.maxHeight*0.97,
                                                        textStyle: getBoldTextStyle(
                                                            color: needWater?AppColors.white:AppColors.blue
                                                        ),
                                                        text:text!,
                                                      )

                                                  ),
                                                ],
                                              );
                                        }
                                    )
                                );
                              },
                            )
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: width*0.005,),
              ],
            ),

            Positioned(
                right: -width*0.03,
                bottom: -height*0.115,
                child: //image
                SizedBox(
                    width: width*0.36,
                    height: height,
                    child: Image.asset('assets/images/plant.png',fit: BoxFit.cover,)
                )
            )
          ],
        ),
      ),
    );
  }
}

class _PlantCardsList extends StatelessWidget {
  final ScrollController scrollController;
  const _PlantCardsList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<HomeViewModel>().plantsOutput,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null ){
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator(),),
            );
          }

          if(snapshot.data!.isEmpty){
            return SliverToBoxAdapter(
              child: Center(child:Text('No Data',style: getBoldTextStyle(),)),
            );
          }else if(snapshot.hasError){
            return SliverToBoxAdapter(
              child: Center(child:Text(snapshot.error.toString(),style: getBoldTextStyle(),))
            );

          } else {
            return SliverFixedExtentList(

              delegate: SliverChildBuilderDelegate(
                 (_, int i) {
                  return _PlantCard(plant:snapshot.data![i]);
                },
                childCount: snapshot.data!.length,
              ), itemExtent: context.height * 0.255,
            );
          }
      }
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