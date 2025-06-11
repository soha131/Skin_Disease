import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../skin_model.dart';
import '../service.dart';
import 'skin_state.dart';

class SkinPredictionCubit extends Cubit<SkinPredictionState> {
  SkinPredictionCubit() : super(SkinPredictionInitial());

  Future<void> dates(File file, BuildContext context) async {
    try {
      emit(SkinPredictionLoading());
      SkinPrediction? result = await ApiService().fetchDataFromApi(file, context);

      if (result != null) {
        emit(SkinPredictionSuccess(result));
      } else {
        emit(SkinPredictionError("No result returned from the API."));
      }
    } catch (e) {
      emit(SkinPredictionError("Error: $e"));
    }
  }
}
