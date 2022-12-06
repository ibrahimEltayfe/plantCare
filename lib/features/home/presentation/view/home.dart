import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:plants_care/core/constants/app_colors.dart';
import 'package:plants_care/core/constants/app_strings.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:plants_care/features/home/presentation/provider/get_plants/get_plants_provider.dart';
import 'package:plants_care/features/home/presentation/provider/home_provider.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../reusable_components/fitted_icon.dart';
import '../../../reusable_components/fittted_text.dart';
import '../../../reusable_components/fractionally_icon.dart';
import '../../../reusable_components/fractionally_text.dart';


class Home extends HookConsumerWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRef = ref.watch(homeProvider);

    final ScrollController scrollController = useScrollController();

    useEffect((){
      homeRef.handleNotifications();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(getPlantsProvider.notifier).getAllPlants();
      });
    }, const []);

    useEffect(() {
      scrollController.addListener(() {
        if(scrollController.position.pixels > context.height*0.102){
          return;
        }
        log(scrollController.position.pixels.toString());
        homeRef.animatedSearchIconInput.add(
            scrollController.position.pixels
        );
      });

      return () => scrollController.removeListener(() { });
    }, [scrollController]);


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
                        preferredSize: Size.fromHeight(context.height*0.045),
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

class _ParallaxSearchIcon extends ConsumerWidget {
  final ScrollController scrollController;
  const _ParallaxSearchIcon({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRef = ref.read(homeProvider);

    return StreamBuilder(
      stream: homeRef.animatedSearchIconOutput,
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
            onTap: (){
              //todo:navigate to search page
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

class _SearchBar extends ConsumerWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRef = ref.watch(homeProvider);

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
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              suffixIcon: StreamBuilder(
                  stream: homeRef.animatedSearchIconOutput,
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

class _PlantCard extends ConsumerWidget {
  final PlantModel plant;
  const _PlantCard({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = context.width;
    final height = context.height*0.222;


    final homeRef = ref.watch(homeProvider);

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
                        text: plant.plantName ?? "...",
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
                        width: width*0.32,
                        height: height*0.19,
                        child: FutureBuilder(
                          future: homeRef.getWaterTimeDuration(plant.id ?? -1),
                          builder: (context, duration) {
                            log(duration.data.toString());
                            String? text = duration.data;
                            bool needWater = false;

                            if(text == null){
                              text = "...";
                            }else{
                              needWater = duration.data == AppStrings.needWater;
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
                                                      height: btnSize.maxHeight*0.95,
                                                      textStyle: getBoldTextStyle(
                                                          color: needWater?AppColors.white:AppColors.blue
                                                      ),
                                                      text:text!,
                                                    ),
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
      ),
    );
  }
}

class _PlantCardsList extends ConsumerWidget{
  final ScrollController scrollController;
  const _PlantCardsList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPlantsState = ref.watch(getPlantsProvider);

    if(getPlantsState is GetPlantsLoading){

      return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),));

    }else if(getPlantsState is GetPlantsError){

      return SliverToBoxAdapter(child: Center(child: Text(getPlantsState.message),));

    }else if(getPlantsState is GetPlantsDataFetched){

      if(getPlantsState.plants.isEmpty){
        return SliverToBoxAdapter(
          child: Center(child:Text('No Data',style: getBoldTextStyle(),)),
        );
      }

      return SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate(
           (_, int i) {
            return _PlantCard(plant:getPlantsState.plants[i]);
          },
          childCount: getPlantsState.plants.length,
        ),

        itemExtent: context.height * 0.255,
      );

    }

    return SliverToBoxAdapter(child: const SizedBox.shrink());
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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