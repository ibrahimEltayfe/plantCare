import 'package:flutter/cupertino.dart';

import '../../features/base/view_model_provider.dart';

extension AppViewModelProvider on BuildContext{
  getViewModel()=> this.dependOnInheritedWidgetOfExactType<ViewModelProvider>();
}