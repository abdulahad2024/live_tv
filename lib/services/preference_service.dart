import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class PreferenceService {
  static PreferenceService? _instance;
  static SharedPreferences? _prefs;

  PreferenceService._();

  static Future<PreferenceService> getInstance() async {
    _instance ??= PreferenceService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Favorites Management
  List<String> getFavorites() {
    return _prefs?.getStringList(AppConstants.keyFavorites) ?? [];
  }

  Future<bool> saveFavorites(List<String> favorites) async {
    return await _prefs?.setStringList(AppConstants.keyFavorites, favorites) ?? false;
  }

  // Theme Management (Dark Mode)
  bool isDarkMode() {
    return _prefs?.getBool(AppConstants.keyDarkMode) ?? true; // Default to dark mode for premium look
  }

  Future<bool> setDarkMode(bool isDark) async {
    return await _prefs?.setBool(AppConstants.keyDarkMode, isDark) ?? false;
  }
}
