import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../models/prediction_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService _apiService;
  bool _isLoading = false;
  PredictionResponse? _result;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _painController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _menstrualController =
      TextEditingController(text: '0');
  final TextEditingController _hormoneController =
      TextEditingController(text: '0');
  final TextEditingController _infertilityController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _painController.dispose();
    _bmiController.dispose();
    _menstrualController.dispose();
    _hormoneController.dispose();
    _infertilityController.dispose();
    super.dispose();
  }

  void _makePrediction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      print('=== Starting Prediction ===');
      print('Age: ${_ageController.text}');
      print('Menstrual: ${_menstrualController.text}');
      print('Pain: ${_painController.text}');
      print('Hormone: ${_hormoneController.text}');
      print('Infertility: ${_infertilityController.text}');
      print('BMI: ${_bmiController.text}');

      // Helper function to parse with defaults
      int parseInt(String value, int defaultValue) {
        if (value.isEmpty) return defaultValue;
        return int.parse(value);
      }

      double parseDouble(String value, double defaultValue) {
        if (value.isEmpty) return defaultValue;
        return double.parse(value);
      }

      final request = PredictionRequest(
        age: parseInt(_ageController.text, 25),
        menstrualIrregularity: parseInt(_menstrualController.text, 0),
        chronicPainLevel: parseDouble(_painController.text, 0.0),
        hormoneAbnormality: parseInt(_hormoneController.text, 0),
        infertility: parseInt(_infertilityController.text, 0),
        bmi: parseDouble(_bmiController.text, 22.0),
      );

      print('Request created: ${request.toJson()}');

      final response = await _apiService.predict(request);

      print('Response received: prediction=${response.prediction}');

      // Save to history
      await _saveToHistory(response);

      setState(() {
        _result = response;
        _isLoading = false;
      });

      _showSuccessSnackBar();
    } catch (e, stackTrace) {
      print('=== ERROR ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _saveToHistory(PredictionResponse response) async {
    try {
      print('=== Saving to history ===');
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('prediction_history') ?? [];
      print('Current history length: ${historyJson.length}');

      // Convert response to JSON
      final responseJson = response.toJson();
      print('Response JSON: $responseJson');
      final jsonString = jsonEncode(responseJson);
      print('JSON string to save: $jsonString');

      // Add new prediction to the beginning
      historyJson.insert(0, jsonString);
      print('New history length: ${historyJson.length}');

      // Keep only the last 50 predictions
      if (historyJson.length > 50) {
        historyJson.removeRange(50, historyJson.length);
      }

      final saved =
          await prefs.setStringList('prediction_history', historyJson);
      print('Prediction saved to history: $saved');

      // Verify it was saved
      final verifyHistory = prefs.getStringList('prediction_history');
      print('Verified history length: ${verifyHistory?.length}');
    } catch (e, stackTrace) {
      print('Error saving to history: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Prediction completed successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _ageController.clear();
    _painController.clear();
    _bmiController.clear();
    _menstrualController.clear();
    _hormoneController.clear();
    _infertilityController.clear();
    setState(() {
      _result = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Risk Assessment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 48,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          ),

          // Top metrics cards (reordered by clinical importance)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 12, AppSpacing.md, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.verified_rounded,
                      '96.96%',
                      'Model Accuracy',
                      emphasis: true,
                      bgColor: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      Icons.input_rounded,
                      '6',
                      'Input Fields',
                      bgColor: AppColors.lavenderLight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      Icons.calendar_today_rounded,
                      'v2.1',
                      'Version',
                      bgColor: AppColors.lavender,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main form area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        boxShadow: [AppShadow.light],
                        border: Border(
                          top: BorderSide(color: AppColors.lavender, width: 3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Patient Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: AppColors.lavenderLight),
                          const SizedBox(height: 12),

                          // Section 1: Basics
                          _buildSectionTitle('Basics'),
                          const SizedBox(height: 10),

                          // Age
                          _buildInputField(
                            controller: _ageController,
                            label: 'Age',
                            hint: '18–100 years',
                            min: 18,
                            max: 100,
                            icon: Icons.calendar_today_rounded,
                            helperText: 'Your current age',
                          ),
                          const SizedBox(height: 12),

                          // BMI
                          _buildInputField(
                            controller: _bmiController,
                            label: 'BMI',
                            hint: '10–60 kg/m²',
                            min: 10,
                            max: 60,
                            isDouble: true,
                            icon: Icons.monitor_weight_rounded,
                            helperText:
                                'Body Mass Index (optional: Height/Weight calc)',
                          ),
                          const SizedBox(height: 14),

                          // Section 2: Symptoms
                          _buildSectionTitle('Symptoms'),
                          const SizedBox(height: 10),

                          // Chronic Pain Level
                          _buildInputField(
                            controller: _painController,
                            label: 'Chronic Pain Level',
                            hint: '0 = none, 10 = severe',
                            min: 0,
                            max: 10,
                            isDouble: true,
                            icon: Icons.health_and_safety_rounded,
                            helperText: '0 (no pain) to 10 (unbearable)',
                          ),
                          const SizedBox(height: 12),

                          // Menstrual Irregularity
                          _buildBinaryFieldImproved(
                            controller: _menstrualController,
                            label: 'Menstrual Irregularity',
                            icon: Icons.calendar_month_rounded,
                          ),
                          const SizedBox(height: 14),

                          // Section 3: Clinical
                          _buildSectionTitle('Clinical Indicators'),
                          const SizedBox(height: 10),

                          // Hormone Abnormality
                          _buildBinaryFieldImproved(
                            controller: _hormoneController,
                            label: 'Hormone Abnormality',
                            icon: Icons.vaccines_rounded,
                          ),
                          const SizedBox(height: 12),

                          // Infertility
                          _buildBinaryFieldImproved(
                            controller: _infertilityController,
                            label: 'Infertility',
                            icon: Icons.family_restroom_rounded,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Enhanced Predict button with pink-to-lavender gradient
                    GestureDetector(
                      onTap: _isLoading ? null : _makePrediction,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.lavender],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _makePrediction,
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isLoading)
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  const Icon(Icons.favorite_rounded,
                                      size: 24, color: Colors.white),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Predict Risk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Uses AI model v2.1',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(0.85),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Result section
                    if (_result != null) _buildResultCard(_result!),
                    if (_errorMessage != null) _buildErrorCard(_errorMessage!),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int min,
    required int max,
    bool isDouble = false,
    required IconData icon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isDouble
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.greyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.greyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            helperText: helperText,
            helperStyle: const TextStyle(fontSize: 11, color: AppColors.grey),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            try {
              final numValue =
                  isDouble ? double.parse(value) : int.parse(value);
              if (numValue < min || numValue > max) {
                return 'Must be $min–$max';
              }
            } catch (e) {
              return 'Invalid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.lavender,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildBinaryFieldImproved({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isYes = controller.text == '1';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.text = isYes ? '1' : '0';
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.greyLight,
                      width: 1.5,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildToggleOption(
                          label: 'No',
                          isSelected: !isYes,
                          onTap: () {
                            controller.text = '0';
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildToggleOption(
                          label: 'Yes',
                          isSelected: isYes,
                          onTap: () {
                            controller.text = '1';
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.greyDark,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label,
      {bool emphasis = false, Color? bgColor}) {
    final Color bg = bgColor ??
        (emphasis ? AppColors.primary : AppColors.primary.withOpacity(0.75));
    final Color shadowColor = bgColor ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasis ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(PredictionResponse result) {
    final Color riskColor = result.prediction < 0.33
        ? AppColors.success
        : result.prediction < 0.67
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: riskColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavender.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: riskColor, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prediction Result',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      result.riskLevel,
                      style: TextStyle(
                        fontSize: 14,
                        color: riskColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border(
                left: BorderSide(color: AppColors.lavender, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Risk Score',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    Text(
                      '${(result.prediction * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lavender,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  child: LinearProgressIndicator(
                    value: result.prediction,
                    minHeight: 8,
                    backgroundColor: AppColors.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Confidence: ${result.confidence}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lavenderLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(color: AppColors.lavender, width: 1),
            ),
            child: Text(
              result.riskDescription,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.error, width: 2),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.greyDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
