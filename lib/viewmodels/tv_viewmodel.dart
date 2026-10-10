import 'package:flutter/foundation.dart';
import '../models/channel_model.dart';
import '../services/api_service.dart';
import '../services/preference_service.dart';

class TvViewModel extends ChangeNotifier {
  final ApiService _apiService;
  late PreferenceService _prefService;

  List<ChannelModel> _allChannels = [];
  Set<String> _favoriteIds = {};

  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isGridView = true;

  // Getters
  List<ChannelModel> get allChannels => _allChannels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isGridView => _isGridView;

  TvViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    init();
  }

  Future<void> init() async {
    _prefService = await PreferenceService.getInstance();
    _loadFavoritesFromPrefs();
    await fetchChannels();
  }

  void _loadFavoritesFromPrefs() {
    final favs = _prefService.getFavorites();
    _favoriteIds = favs.toSet();
  }

  Future<void> fetchChannels() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final channels = await _apiService.fetchBangladeshChannels();
      _allChannels = channels.map((c) {
        return c.copyWith(isFavorite: _favoriteIds.contains(c.id));
      }).toList();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshChannels() async {
    await fetchChannels();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  Future<void> toggleFavorite(ChannelModel channel) async {
    final channelId = channel.id;
    if (_favoriteIds.contains(channelId)) {
      _favoriteIds.remove(channelId);
    } else {
      _favoriteIds.add(channelId);
    }

    await _prefService.saveFavorites(_favoriteIds.toList());

    // Update in list
    _allChannels = _allChannels.map((c) {
      if (c.id == channelId) {
        return c.copyWith(isFavorite: _favoriteIds.contains(channelId));
      }
      return c;
    }).toList();

    notifyListeners();
  }

  // Filtered channels based on search and category
  List<ChannelModel> get filteredChannels {
    return _allChannels.where((channel) {
      // Category match
      bool categoryMatch = true;
      if (_selectedCategory != 'all') {
        categoryMatch = channel.categories.any(
          (cat) => cat.toLowerCase() == _selectedCategory.toLowerCase(),
        );
      }

      // Search match (checks name, alt names, network, category)
      bool searchMatch = true;
      if (_searchQuery.isNotEmpty) {
        final nameMatch = channel.name.toLowerCase().contains(_searchQuery);
        final altMatch = channel.altNames.any((alt) => alt.toLowerCase().contains(_searchQuery));
        final networkMatch = channel.network?.toLowerCase().contains(_searchQuery) ?? false;
        final categoryMatchText = channel.categoryBanglaName.toLowerCase().contains(_searchQuery);
        searchMatch = nameMatch || altMatch || networkMatch || categoryMatchText;
      }

      return categoryMatch && searchMatch;
    }).toList();
  }

  // Favorite channels list
  List<ChannelModel> get favoriteChannels {
    return _allChannels.where((c) => c.isFavorite).toList();
  }

  // Featured channels for top carousel
  List<ChannelModel> get featuredChannels {
    // Return up to 6 channels that have active streams
    final active = _allChannels.where((c) => c.hasActiveStream).toList();
    if (active.length > 6) {
      return active.sublist(0, 6);
    }
    return active.isNotEmpty ? active : _allChannels.take(6).toList();
  }

  // Extract all available categories from channels
  List<String> get availableCategories {
    final categories = <String>{'all'};
    for (final channel in _allChannels) {
      for (final cat in channel.categories) {
        if (cat.isNotEmpty) {
          categories.add(cat.toLowerCase());
        }
      }
    }
    return categories.toList();
  }
}
