import 'stream_model.dart';
import 'feed_model.dart';
import '../utils/constants.dart';

class ChannelModel {
  final String id;
  final String name;
  final List<String> altNames;
  final String? network;
  final List<String> owners;
  final String country;
  final List<String> categories;
  final bool isNsfw;
  final String? website;

  // Additional linked fields
  String? logoUrl;
  List<StreamModel> streams;
  List<FeedModel> feeds;
  bool isFavorite;

  ChannelModel({
    required this.id,
    required this.name,
    required this.altNames,
    this.network,
    required this.owners,
    required this.country,
    required this.categories,
    required this.isNsfw,
    this.website,
    this.logoUrl,
    List<StreamModel>? streams,
    List<FeedModel>? feeds,
    this.isFavorite = false,
  })  : streams = streams ?? [],
        feeds = feeds ?? [];

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      altNames: (json['alt_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      network: json['network']?.toString(),
      owners: (json['owners'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      country: json['country']?.toString() ?? '',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isNsfw: json['is_nsfw'] == true,
      website: json['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alt_names': altNames,
      'network': network,
      'owners': owners,
      'country': country,
      'categories': categories,
      'is_nsfw': isNsfw,
      'website': website,
      'logo_url': logoUrl,
      'is_favorite': isFavorite,
    };
  }

  // Helper getters
  String get primaryCategory => categories.isNotEmpty ? categories.first : 'general';

  String get categoryBanglaName {
    final cat = primaryCategory.toLowerCase();
    return AppConstants.categoryTranslations[cat] ?? AppConstants.categoryTranslations['other']!;
  }

  String? get activeStreamUrl {
    if (streams.isEmpty) return null;
    // Prefer online status stream if available
    final onlineStream = streams.firstWhere(
      (s) => s.status?.toLowerCase() == 'online',
      orElse: () => streams.first,
    );
    return onlineStream.url;
  }

  bool get hasActiveStream => streams.isNotEmpty && activeStreamUrl != null;

  ChannelModel copyWith({
    String? logoUrl,
    List<StreamModel>? streams,
    List<FeedModel>? feeds,
    bool? isFavorite,
  }) {
    final channel = ChannelModel(
      id: id,
      name: name,
      altNames: altNames,
      network: network,
      owners: owners,
      country: country,
      categories: categories,
      isNsfw: isNsfw,
      website: website,
      logoUrl: logoUrl ?? this.logoUrl,
      streams: streams ?? this.streams,
      feeds: feeds ?? this.feeds,
      isFavorite: isFavorite ?? this.isFavorite,
    );
    return channel;
  }
}
