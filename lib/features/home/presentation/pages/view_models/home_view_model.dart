import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:plants_care/features/base/base_view_model.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs,HomeViewModelOutputs{
  FocusNode focusNode = FocusNode();

  StreamController<double> animatedSearchIconController = StreamController.broadcast();
  StreamController<FocusNode> searchFieldFocusNodeController = StreamController();

  //public functions
  @override
  void start() {
    animatedSearchIconInput.add(0.0);
    searchFieldFocusNodeInput.add(focusNode);
  }

  @override
  void dispose() {
    animatedSearchIconController.close();
    searchFieldFocusNodeController.close();
  }

  void searchFieldRequestFocus(){
    focusNode.requestFocus();
  }

  //private functions


  //inputs
  @override
  Sink<double> get animatedSearchIconInput => animatedSearchIconController.sink;

  @override
  Sink<FocusNode> get searchFieldFocusNodeInput => searchFieldFocusNodeController.sink;
  //outputs
  @override
  Stream<double> get animatedSearchIconOutput => animatedSearchIconController.stream;

  @override
  Stream<FocusNode> get searchFieldFocusNodeOutput => searchFieldFocusNodeController.stream;

}

abstract class HomeViewModelInputs{
  Sink<double> get animatedSearchIconInput;
  Sink<FocusNode> get searchFieldFocusNodeInput;
}

abstract class HomeViewModelOutputs{
  Stream<double> get animatedSearchIconOutput;
  Stream<FocusNode> get searchFieldFocusNodeOutput;
}