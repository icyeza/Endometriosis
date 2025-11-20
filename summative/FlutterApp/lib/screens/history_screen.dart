import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../models/prediction_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PredictionResponse> _history = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    print('=== Loading history ===');
    _prefs = await SharedPreferences.getInstance();
    final historyJson = _prefs.getStringList('prediction_history') ?? [];
    print('Found ${historyJson.length} items in history');

    if (historyJson.isNotEmpty) {
      print('First item: ${historyJson.first}');
    }

    try {
      setState(() {
        _history = historyJson
            .map((json) {
              print('Parsing JSON: $json');
              return PredictionResponse.fromJson(jsonDecode(json));
            })
            .toList()
            .reversed
            .toList();
        print('Loaded ${_history.length} predictions');
      });
    } catch (e, stackTrace) {
      print('Error loading history: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _clearHistory() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all predictions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _prefs.remove('prediction_history');
              setState(() => _history.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('History cleared')));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(int index) async {
    final newHistory = List<PredictionResponse>.from(_history);
    newHistory.removeAt(index);
    await _prefs.setStringList(
      'prediction_history',
      newHistory.map((p) => jsonEncode(p.toJson())).toList(),
    );
    setState(() => _history = newHistory);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Prediction removed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction History'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: _history.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: _clearHistory,
                ),
              ]
            : null,
      ),
      body: _history.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _history.length,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemBuilder: (context, index) {
                return _buildHistoryCard(_history[index], index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No Predictions Yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppColors.greyDark),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Make a prediction to see it here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(PredictionResponse prediction, int index) {
    final Color riskColor = prediction.prediction < 0.33
        ? AppColors.success
        : prediction.prediction < 0.67
            ? AppColors.warning
            : AppColors.error;

    final formattedDate =
        '${prediction.timestamp.year}-${prediction.timestamp.month.toString().padLeft(2, '0')}-${prediction.timestamp.day.toString().padLeft(2, '0')} ${prediction.timestamp.hour.toString().padLeft(2, '0')}:${prediction.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [AppShadow.light],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.lg),
                topRight: Radius.circular(AppBorderRadius.lg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.riskLevel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: riskColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(prediction.prediction * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      prediction.confidence,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataRow('Age', '${prediction.inputData.age} years'),
                _buildDataRow(
                  'BMI',
                  prediction.inputData.bmi.toStringAsFixed(1),
                ),
                _buildDataRow(
                  'Pain Level',
                  prediction.inputData.chronicPainLevel.toStringAsFixed(1),
                ),
                _buildDataRow(
                  'Menstrual Irregularity',
                  prediction.inputData.menstrualIrregularity == 1
                      ? 'Yes'
                      : 'No',
                ),
                _buildDataRow(
                  'Hormone Abnormality',
                  prediction.inputData.hormoneAbnormality == 1 ? 'Yes' : 'No',
                ),
                _buildDataRow(
                  'Infertility',
                  prediction.inputData.infertility == 1 ? 'Yes' : 'No',
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _deleteItem(index),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
