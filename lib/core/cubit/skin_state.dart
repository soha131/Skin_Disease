
import '../models/skin_model.dart';

abstract class SkinPredictionState {}

class SkinPredictionInitial extends SkinPredictionState {}

class SkinPredictionLoading extends SkinPredictionState {}

class SkinPredictionSuccess extends SkinPredictionState {
  final SkinPrediction prediction;
  SkinPredictionSuccess(this.prediction);
}

class SkinPredictionError extends SkinPredictionState {
  final String message;
  SkinPredictionError(this.message);
}
