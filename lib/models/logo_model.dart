class LogoModel {
  final String channel;
  final String url;
  final String? format;

  LogoModel({
    required this.channel,
    required this.url,
    this.format,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      channel: json['channel']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      format: json['format']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'url': url,
      'format': format,
    };
  }
}
