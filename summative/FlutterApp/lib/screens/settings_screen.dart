import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ApiService _apiService;
  late TextEditingController _urlController;
  late SharedPreferences _prefs;
  String _connectionStatus = 'Unknown';
  bool _isCheckingConnection = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _urlController = TextEditingController();
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final url = await _apiService.getBaseUrl();
    _urlController.text = url;
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isCheckingConnection = true;
      _connectionStatus = 'Checking...';
    });

    try {
      await _apiService.getHealth();
      setState(() {
        _connectionStatus = 'Connected ✓';
        _isCheckingConnection = false;
      });
      _showSuccessDialog(
        'API Connection',
        'Successfully connected to the API!',
      );
    } catch (e) {
      setState(() {
        _connectionStatus = 'Disconnected ✗';
        _isCheckingConnection = false;
      });
      _showErrorDialog('Connection Failed', e.toString());
    }
  }

  Future<void> _saveUrl() async {
    if (_urlController.text.isEmpty) {
      _showErrorDialog('Error', 'URL cannot be empty');
      return;
    }

    try {
      await _apiService.setBaseUrl(_urlController.text);
      setState(() {
        _connectionStatus = 'Unknown';
      });
      _showSuccessDialog('Success', 'API URL updated successfully!');
    } catch (e) {
      _showErrorDialog('Error', e.toString());
    }
  }

  Future<void> _resetToDefault() async {
    _urlController.text = 'http://localhost:8000';
    await _saveUrl();
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        titleTextStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Configuration Section
            _buildSectionHeader('API Configuration'),
            const SizedBox(height: AppSpacing.md),
            _buildSettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Base URL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'http://localhost:8000',
                      prefixIcon: const Icon(
                        Icons.link_rounded,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.greyLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.greyLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.greyLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetToDefault,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveUrl,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Connection Status Section
            _buildSectionHeader('Connection Status'),
            const SizedBox(height: AppSpacing.md),
            _buildStatusCard(),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCheckingConnection ? null : _checkConnection,
                icon: _isCheckingConnection
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.cloud_queue_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                ),
                label: const Text(
                  'Check Connection',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // App Information Section
            _buildSectionHeader('About'),
            const SizedBox(height: AppSpacing.md),
            _buildSettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutRow('App Name', 'Endometriosis Prediction'),
                  _buildAboutRow('Version', '1.0.0'),
                  _buildAboutRow('API Version', 'v1.0'),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'This app uses a machine learning model to predict endometriosis risk based on patient data.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [AppShadow.light],
      ),
      child: child,
    );
  }

  Widget _buildStatusCard() {
    Color statusColor = AppColors.grey;
    IconData statusIcon = Icons.help_outline_rounded;

    if (_connectionStatus.contains('Connected')) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
    } else if (_connectionStatus.contains('Disconnected')) {
      statusColor = AppColors.error;
      statusIcon = Icons.error_rounded;
    } else if (_connectionStatus == 'Checking...') {
      statusColor = AppColors.warning;
      statusIcon = Icons.hourglass_bottom_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: statusColor, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 32),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                _connectionStatus,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
