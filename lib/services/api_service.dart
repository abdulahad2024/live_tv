import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel_model.dart';
import '../models/stream_model.dart';
import '../models/feed_model.dart';
import '../models/logo_model.dart';
import '../utils/constants.dart';

class ApiService {


  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ChannelModel>> fetchBangladeshChannels() async {
    try {
      final results = await Future.wait([
        _fetchJsonList(AppConstants.channelsApiUrl),
        _fetchJsonList(AppConstants.streamsApiUrl),
        _fetchJsonList(AppConstants.feedsApiUrl),
        _fetchJsonList(AppConstants.logosApiUrl),
      ]).timeout(const Duration(seconds: 15));

      final rawChannels = results[0];
      final rawStreams = results[1];
      final rawFeeds = results[2];
      final rawLogos = results[3];

      final bdChannels = rawChannels
          .map((item) => ChannelModel.fromJson(item as Map<String, dynamic>))
          .where((channel) => channel.country.toUpperCase() == AppConstants.targetCountry)
          .toList();

      final bdChannelIds = bdChannels.map((c) => c.id).toSet();

      final Map<String, List<StreamModel>> streamsMap = {};
      for (final item in rawStreams) {
        final stream = StreamModel.fromJson(item as Map<String, dynamic>);
        if (bdChannelIds.contains(stream.channel)) {
          streamsMap.putIfAbsent(stream.channel, () => []).add(stream);
        }
      }

      final Map<String, List<FeedModel>> feedsMap = {};
      for (final item in rawFeeds) {
        final feed = FeedModel.fromJson(item as Map<String, dynamic>);
        if (bdChannelIds.contains(feed.channel)) {
          feedsMap.putIfAbsent(feed.channel, () => []).add(feed);
        }
      }

      final Map<String, String> logoMap = {};
      for (final item in rawLogos) {
        final logo = LogoModel.fromJson(item as Map<String, dynamic>);
        if (bdChannelIds.contains(logo.channel) && logo.url.isNotEmpty) {
          logoMap.putIfAbsent(logo.channel, () => logo.url);
        }
      }

      for (final channel in bdChannels) {
        channel.logoUrl = logoMap[channel.id];
        channel.streams = streamsMap[channel.id] ?? [];
        channel.feeds = feedsMap[channel.id] ?? [];
      }

      bdChannels.sort((a, b) {
        if (a.hasActiveStream && !b.hasActiveStream) return -1;
        if (!a.hasActiveStream && b.hasActiveStream) return 1;
        return a.name.compareTo(b.name);
      });

      return bdChannels;
    } catch (e) {
      throw Exception('চ্যানেল ডাটা লোড করতে সমস্যা হয়েছে: $e');
    }
  }

  Future<List<dynamic>> _fetchJsonList(String url) async {
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is List) {
        return decoded;
      }
      return [];
    } else {
      throw Exception('API সার্ভারে ত্রুটি (${response.statusCode})');
    }
  }
}
