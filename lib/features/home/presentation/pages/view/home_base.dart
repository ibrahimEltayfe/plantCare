import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plants_care/core/constants/app_icons.dart';
import 'package:plants_care/core/constants/app_styles.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/features/home/presentation/pages/view/home.dart';
import 'package:plants_care/features/home/presentation/reusable_components/fittted_text.dart';

import '../../../../../core/constants/app_colors.dart';

class HomeBasePage extends StatefulWidget {
  const HomeBasePage({Key? key}) : super(key: key);

  @override
  State<HomeBasePage> createState() => _HomeBasePageState();
}

class _HomeBasePageState extends State<HomeBasePage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottomNavBar(
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        icons:[
          AppIcons.waterDrop,
          AppIcons.search,
          AppIcons.waterDrop,
          AppIcons.search,
        ],
        texts:[
          "item item",
          "item item",
          "item item",
          "item item"
        ],
        activeColor: AppColors.primaryColor,
        disabledColor: AppColors.grey,
        currentIndex:currentIndex,
      ),
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: IndexedStack(
          index: 0,

          children: [
            Home()
          ],
        ),
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
    final height = context.height*0.095;
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
        children: List.generate(icons.length, (i){
            return _NavBarItem(
              index: i,
              textStyle: getBoldTextStyle(),
              icon: icons[i],
              text: texts[i],
              iconColor:activeColor,
              onTap: onTap,
            );
          })

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
