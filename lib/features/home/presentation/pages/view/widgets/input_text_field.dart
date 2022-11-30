import 'package:flutter/material.dart';
import 'package:plants_care/core/extensions/size_config.dart';
import 'package:plants_care/core/extensions/view_model_provider.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/app_styles.dart';
import '../../../../../reusable_components/fractionally_icon.dart';

class InputTextField extends StatelessWidget {
  final String hint;
  final TextInputAction textInputAction;
  final IconData? icon;
  final Color activeColor;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  const InputTextField({Key? key,this.textAlign, required this.hint, required this.textInputAction, this.icon, required this.activeColor, this.keyboardType, required this.validator, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width*0.92,
        height: context.height * 0.075,
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
        child: TextFormField(
          controller: controller,
          validator: validator,

          cursorColor: AppColors.primaryColor,
          textInputAction: textInputAction,

          keyboardType: keyboardType,
          textAlign: textAlign ?? TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          style: getRegularTextStyle(color: AppColors.primaryColor),
          expands:true,
          maxLines: null,

          decoration: InputDecoration(
            isDense:true,
            prefixIcon: (icon!=null) ?FractionallyIcon(
                widthFactor: 0.2,
                heightFactor: 0.4,
                color: activeColor,
                icon: icon!
            ):null,

            hintText:hint,
            hintStyle: getRegularTextStyle(color: AppColors.grey),

            filled: false,

            errorStyle: TextStyle(fontSize: 0,height: -1),

            //borders
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: activeColor)
            ),

            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none
            ),

            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.darkRed)
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.darkRed)
            ),
          ),
        )
    );
  }
}