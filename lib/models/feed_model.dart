class FeedModel {
  final String channel;
  final String? name;
  final String? format;
  final String? quality;

  FeedModel({
    required this.channel,
    this.name,
    this.format,
    this.quality,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      channel: json['channel']?.toString() ?? '',
      name: json['name']?.toString(),
      format: json['format']?.toString(),
      quality: json['quality']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'name': name,
      'format': format,
      'quality': quality,
    };
  }
}
