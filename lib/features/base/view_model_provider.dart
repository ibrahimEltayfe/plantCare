import 'package:flutter/cupertino.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';

class ViewModelProvider extends InheritedWidget{
  final HomeViewModel viewModel;
  const ViewModelProvider({super.key, required super.child,required this.viewModel});

  @override
  bool updateShouldNotify(covariant ViewModelProvider oldWidget) {
    return viewModel != oldWidget.viewModel;
  }

}