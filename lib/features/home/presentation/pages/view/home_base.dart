import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plants_care/core/constants/app_icons.dart';
import 'package:plants_care/core/constants/app_styles.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/core/extensions/view_model_provider.dart';
import 'package:plants_care/core/utils/injector.dart' as di;
import 'package:plants_care/core/utils/notification_helper.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/presentation/pages/view/home.dart';
import 'package:plants_care/features/home/presentation/pages/view/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../reusable_components/fractionally_icon.dart';
import '../view_models/home_view_model.dart';

class HomeBasePage extends StatefulWidget {
  const HomeBasePage({Key? key}) : super(key: key);

  @override
  State<HomeBasePage> createState() => _HomeBasePageState();
}

class _HomeBasePageState extends State<HomeBasePage> {
  int currentIndex = 0;

  @override
  void initState() {
    NotificationHelper.checkPermission(context);

    super.initState();
  }

  @override
  void dispose() {
    //AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=>di.injector<HomeViewModel>()..start()..getAllPlants(),
      child: Scaffold(
          backgroundColor: AppColors.bgColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: const _FloatingActionButton(),

          bottomNavigationBar: _BottomNavBar(
            icons:const [
              AppIcons.plant,
              AppIcons.settings,
            ],
            texts:const [
              "Plants",
              "Settings",
            ],
            activeColor: AppColors.primaryColor,
            disabledColor: AppColors.grey,
            currentIndex:currentIndex,
            onTap: (i) {
              setState(() {
                currentIndex = i;
              });
            },
          ),
          body: SafeArea(
            child: IndexedStack(
              index: 0,

              children: [
                Home()
              ],
            ),
          ),
        ),
    );

  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.width*0.05),
                  topRight: Radius.circular(context.width*0.05)
              )
          ),
          builder: (ctx) {
            return Provider.value(
                value: context.read<HomeViewModel>(),
                child: BottomSheetContent()
            );
          },
        );
      },

      backgroundColor: AppColors.primaryColor,
      child: const FractionallyIcon(
        widthFactor: 0.48,
        heightFactor: 0.48,
        color: AppColors.white,
        icon: FontAwesomeIcons.plus,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final List<IconData> icons;
  final List<String> texts;
  final int currentIndex;
  final Color activeColor;
  final Color disabledColor;

  const _BottomNavBar({Key? key, required this.onTap, required this.icons, required this.texts, required this.currentIndex, required this.activeColor, required this.disabledColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.height*0.092;
    final width = context.width;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.width*0.06),
            topRight:  Radius.circular(context.width*0.06),
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.lightGrey,
                blurRadius: 6,
                offset: Offset(0,-context.height*0.002)
            )
          ]
      ),

      child: Row(
        children:[
          ...List.generate(icons.length, (i){
            return _NavBarItem(
              index: i,
              textStyle: currentIndex==i
                  ? getBoldTextStyle(color: AppColors.primaryColor)
                  :getBoldTextStyle(color: AppColors.grey),
              icon: icons[i],
              text: texts[i],
              iconColor:currentIndex==i? activeColor : disabledColor,
              onTap: onTap,
            );
          }).reversed,

          SizedBox(width: width*0.15,),
        ]

      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  final int index;
  final Function(int) onTap;
  const _NavBarItem({Key? key, required this.icon, required this.iconColor, required this.text, required this.textStyle, required this.index, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ()=> onTap(index),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width*0.007,vertical:context.height*0.007 ),
          child: Column(
            children: [

              Expanded(
                flex: 3,
                child: FittedBox(
                  child: FaIcon(
                    icon,
                    color: iconColor,
                  ),
                ),
              ),

              SizedBox(height: context.height*0.008,),

              Expanded(
                flex: 2,
                child: FittedBox(
                  child: Text(
                    text,
                    style: textStyle,
                  ),
                ),
              ),

              SizedBox(height: context.height*0.006,),

              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor
                  ),
                )
              )

            ],
          ),
        ),
      ),
    );
  }
}

