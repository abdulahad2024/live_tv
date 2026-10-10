class StreamModel {
  final String channel;
  final String url;
  final String? httpReferrer;
  final String? userAgent;
  final String? quality;
  final String? status;

  StreamModel({
    required this.channel,
    required this.url,
    this.httpReferrer,
    this.userAgent,
    this.quality,
    this.status,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      channel: json['channel']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      httpReferrer: json['http_referrer']?.toString(),
      userAgent: json['user_agent']?.toString(),
      quality: json['quality']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'url': url,
      'http_referrer': httpReferrer,
      'user_agent': userAgent,
      'quality': quality,
      'status': status,
    };
  }
}
