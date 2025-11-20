class PredictionRequest {
  final int age;
  final int menstrualIrregularity;
  final double chronicPainLevel;
  final int hormoneAbnormality;
  final int infertility;
  final double bmi;

  PredictionRequest({
    required this.age,
    required this.menstrualIrregularity,
    required this.chronicPainLevel,
    required this.hormoneAbnormality,
    required this.infertility,
    required this.bmi,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'menstrual_irregularity': menstrualIrregularity,
      'chronic_pain_level': chronicPainLevel,
      'hormone_level_abnormality': hormoneAbnormality,
      'infertility': infertility,
      'bmi': bmi,
    };
  }
}

class PredictionResponse {
  final double prediction;
  final String confidence;
  final PredictionRequest inputData;
  final DateTime timestamp;

  PredictionResponse({
    required this.prediction,
    required this.confidence,
    required this.inputData,
    required this.timestamp,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    print('=== PredictionResponse.fromJson ===');
    print('JSON type: ${json.runtimeType}');
    print('JSON keys: ${json.keys.toList()}');
    print('JSON: $json');

    try {
      final inputDataMap = json['input_data'] as Map<String, dynamic>? ?? {};
      print('Input data map: $inputDataMap');

      final prediction = json['prediction'];
      print('Prediction value: $prediction (type: ${prediction.runtimeType})');

      final confidence = json['confidence'];
      print('Confidence value: $confidence (type: ${confidence.runtimeType})');

      // Parse timestamp if it exists, otherwise use current time
      DateTime timestamp;
      if (json.containsKey('timestamp') && json['timestamp'] != null) {
        try {
          timestamp = DateTime.parse(json['timestamp'] as String);
        } catch (e) {
          print('Error parsing timestamp: $e');
          timestamp = DateTime.now();
        }
      } else {
        timestamp = DateTime.now();
      }

      return PredictionResponse(
        prediction: (prediction as num).toDouble(),
        confidence: confidence as String,
        inputData: PredictionRequest(
          age: (inputDataMap['age'] as num?)?.toInt() ?? 0,
          menstrualIrregularity:
              (inputDataMap['menstrual_irregularity'] as num?)?.toInt() ?? 0,
          chronicPainLevel:
              (inputDataMap['chronic_pain_level'] as num?)?.toDouble() ?? 0.0,
          hormoneAbnormality:
              (inputDataMap['hormone_level_abnormality'] as num?)?.toInt() ?? 0,
          infertility: (inputDataMap['infertility'] as num?)?.toInt() ?? 0,
          bmi: (inputDataMap['bmi'] as num?)?.toDouble() ?? 0.0,
        ),
        timestamp: timestamp,
      );
    } catch (e, stackTrace) {
      print('=== ERROR in fromJson ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'confidence': confidence,
      'input_data': inputData.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get riskLevel {
    if (prediction < 0.33) return 'Low Risk';
    if (prediction < 0.67) return 'Medium Risk';
    return 'High Risk';
  }

  String get riskDescription {
    if (prediction < 0.33) {
      return 'Low probability of endometriosis based on input parameters.';
    } else if (prediction < 0.67) {
      return 'Medium probability of endometriosis. Consider consulting a healthcare provider.';
    } else {
      return 'High probability of endometriosis. Immediate consultation recommended.';
    }
  }
}
