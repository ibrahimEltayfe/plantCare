import 'package:flutter/cupertino.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';

class ViewModelProvider extends InheritedWidget{
  final dynamic viewModel;
  const ViewModelProvider({super.key, required super.child,required this.viewModel});


  static ViewModelProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ViewModelProvider oldWidget) {
    return viewModel != oldWidget.viewModel;
  }

}