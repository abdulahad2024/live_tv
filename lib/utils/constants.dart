import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'লাইভ টিভি বাংলাদেশ';
  static const String appSubtitle = 'বাংলাদেশের সকল টিভি চ্যানেল একসাথে';

  // IPTV-org APIs
  static const String channelsApiUrl = 'https://iptv-org.github.io/api/channels.json';
  static const String streamsApiUrl = 'https://iptv-org.github.io/api/streams.json';
  static const String feedsApiUrl = 'https://iptv-org.github.io/api/feeds.json';
  static const String logosApiUrl = 'https://iptv-org.github.io/api/logos.json';

  // Target Country Code
  static const String targetCountry = 'BD';

  // Shared Preferences Keys
  static const String keyFavorites = 'bd_tv_favorites';
  static const String keyDarkMode = 'bd_tv_dark_mode';

  // Category Map in Bangla
  static const Map<String, String> categoryTranslations = {
    'all': 'সব চ্যানেল',
    'news': 'খবর',
    'entertainment': 'বিনোদন',
    'sports': 'খেলাধুলা',
    'general': 'সাধারণ',
    'music': 'সংগীত',

    'business': 'ব্যবসা',
    'family': 'পরিবার',

    'kids': 'বাচ্চাদের',
    'religious': 'ধর্মীয়',
    'movies': 'চলচ্চিত্র',
    'culture': 'সংস্কৃতি',
    'legislative': 'সংসদ ও আইন',
    'education': 'শিক্ষা',
    'lifestyle': 'লাইফস্টাইল',
    'other': 'অন্যান্য',
  };

  // Category Icons
  static const Map<String, IconData> categoryIcons = {
    'all': Icons.grid_view_rounded,
    'news': Icons.newspaper_rounded,
    'entertainment': Icons.tv_rounded,
    'sports': Icons.sports_soccer_rounded,
    'general': Icons.live_tv_rounded,
    'music': Icons.music_note_rounded,
    'kids': Icons.child_care_rounded,
    'religious': Icons.mosque_rounded,
    'movies': Icons.movie_filter_rounded,
    'culture': Icons.museum_rounded,
    'legislative': Icons.gavel_rounded,
    'education': Icons.school_rounded,
    'lifestyle': Icons.style_rounded,
    'other': Icons.category_rounded,
  };
}

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF10B981); // Emerald Green
  static const Color primaryVariantLight = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF0284C7); // Teal/Blue Accent
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF10B981);
  static const Color primaryVariantDark = Color(0xFF047857);
  static const Color secondaryDark = Color(0xFF38BDF8);
  static const Color bgDark = Color(0xFF090D16); // Deep Obsidian
  static const Color cardDark = Color(0xFF151C2C); // Deep Navy Card
  static const Color textDark = Color(0xFFF1F5F9);
  static const Color textMutedDark = Color(0xFF94A3B8);

  // Accent & Status Colors
  static const Color liveBadge = Color(0xFFEF4444); // Crimson Red for LIVE
  static const Color favoriteHeart = Color(0xFFF43F5E);
  static const Color goldAccent = Color(0xFFF59E0B);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
}
