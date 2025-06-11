class SkinPrediction {
  final String predictedClass;
  final String description;

  SkinPrediction({
    required this.predictedClass,
    required this.description,
  });

  factory SkinPrediction.fromJson(Map<String, dynamic> json) {
    return SkinPrediction(
      predictedClass: json['predicted_class'] ?? 'Unknown',
      description: json['description'] ?? 'No description available.',
    );
  }
}
