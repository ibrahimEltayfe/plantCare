import 'package:flutter/material.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/presentation/pages/view_models/home_view_model.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final HomeViewModel homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
        viewModel: homeViewModel,
        child: Scaffold(
          body:SafeArea(
            child: Column(
              children: [

              ],
            ),
          ),
        ),
    );
  }
}
