import 'package:flutter/material.dart';
import '../services/preference_service.dart';

class ThemeViewModel extends ChangeNotifier {
  late PreferenceService _prefService;
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeViewModel() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _prefService = await PreferenceService.getInstance();
    _isDarkMode = _prefService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    await _prefService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
