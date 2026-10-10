import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import '../../models/channel_model.dart';
import '../../models/stream_model.dart';
import '../../viewmodels/tv_viewmodel.dart';
import '../../utils/constants.dart';
import '../../widgets/channel_card.dart';

class LivePlayerScreen extends StatefulWidget {
  final ChannelModel channel;

  const LivePlayerScreen({
    super.key,
    required this.channel,
  });

  @override
  State<LivePlayerScreen> createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  late ChannelModel _currentChannel;
  StreamModel? _selectedStream;

  bool _isPlayerLoading = true;
  bool _hasPlayerError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _currentChannel = widget.channel;
    _selectInitialStream();
    _initPlayer();
  }

  void _selectInitialStream() {
    if (_currentChannel.streams.isNotEmpty) {
      _selectedStream = _currentChannel.streams.firstWhere(
            (s) => s.status?.toLowerCase() == 'online',
        orElse: () => _currentChannel.streams.first,
      );
    } else {
      _selectedStream = null;
    }
  }

  Future<void> _initPlayer() async {
    setState(() {
      _isPlayerLoading = true;
      _hasPlayerError = false;
      _errorMessage = '';
    });

    _disposeControllers();

    if (_selectedStream == null || _selectedStream!.url.isEmpty) {
      setState(() {
        _isPlayerLoading = false;
        _hasPlayerError = true;
        _errorMessage = 'এই চ্যানেলের কোনো সরাসরি সম্প্রচার লিঙ্ক পাওয়া যায়নি।';
      });
      return;
    }

    try {
      final uri = Uri.parse(_selectedStream!.url);

      final httpHeaders = <String, String>{};
      if (_selectedStream!.httpReferrer != null &&
          _selectedStream!.httpReferrer!.isNotEmpty) {
        httpHeaders['Referer'] = _selectedStream!.httpReferrer!;
      }
      if (_selectedStream!.userAgent != null &&
          _selectedStream!.userAgent!.isNotEmpty) {
        httpHeaders['User-Agent'] = _selectedStream!.userAgent!;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
        httpHeaders: httpHeaders,
      );

      await _videoPlayerController!.initialize();

      // Screen bondho hoye gele aar kichu korbo na
      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        isLive: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio > 0
            ? _videoPlayerController!.value.aspectRatio
            : 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'স্ট্রিম চালু করা সম্ভব হয়নি',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'লিঙ্ক অকার্যকর বা সংযোগ সমস্যা হতে পারে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _initPlayer,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('পুনরায় চেষ্টা করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        _isPlayerLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPlayerLoading = false;
        _hasPlayerError = true;
        _errorMessage = 'প্লেয়ার চালুতে ত্রুটি: ${e.toString()}';
      });
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _chewieController = null;
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  void _switchStream(StreamModel stream) {
    if (_selectedStream?.url == stream.url) return;
    setState(() {
      _selectedStream = stream;
    });
    _initPlayer();
  }

  void _switchChannel(ChannelModel newChannel) {
    if (_currentChannel.id == newChannel.id) return;
    setState(() {
      _currentChannel = newChannel;
    });
    _selectInitialStream();
    _initPlayer();
  }

  @override
  void dispose() {
    _disposeControllers();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tvViewModel = context.watch<TvViewModel>();

    // Get list of other channels for carousel/list
    final otherChannels = tvViewModel.allChannels
        .where((c) => c.id != _currentChannel.id)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: Text(_currentChannel.name),
        actions: [
          IconButton(
            icon: Icon(
              _currentChannel.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color:
              _currentChannel.isFavorite ? AppColors.favoriteHeart : null,
            ),
            onPressed: () {
              tvViewModel.toggleFavorite(_currentChannel);
              setState(() {
                _currentChannel = _currentChannel.copyWith(
                  isFavorite: !_currentChannel.isFavorite,
                );
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Box
              Container(
                width: double.infinity,
                height: 230,
                color: Colors.black,
                child: _isPlayerLoading
                    ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                          color: AppColors.primaryLight),
                      SizedBox(height: 12),
                      Text(
                        'লাইভ স্ট্রিম সংযোগী হচ্ছে...',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                )
                    : _hasPlayerError
                    ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.signal_wifi_off_rounded,
                            color: Colors.amberAccent, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _initPlayer,
                          icon: const Icon(Icons.refresh_rounded,
                              size: 18),
                          label: const Text('আবার চেষ্টা করুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                  child: Text(
                    'প্লেয়ার রেন্ডার করা যাচ্ছে না',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Channel Header Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentChannel.categoryBanglaName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Live status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.liveBadge.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.fiber_manual_record,
                                  size: 10, color: AppColors.liveBadge),
                              SizedBox(width: 4),
                              Text(
                                'লাইভ স্ট্রিমিং',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.liveBadge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      _currentChannel.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                        isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),

                    if (_currentChannel.network != null &&
                        _currentChannel.network!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'নেটওয়ার্ক / মালিক: ${_currentChannel.network}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Multiple Stream Selector (If channel has multiple streams)
              if (_currentChannel.streams.length > 1) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'অন্যান্য স্ট্রিম কোয়ালিটি / লিঙ্ক বেছে নিন:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                          isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _currentChannel.streams.length,
                          itemBuilder: (context, index) {
                            final stream = _currentChannel.streams[index];
                            final isSelected =
                                _selectedStream?.url == stream.url;
                            final qualityLabel = stream.quality != null &&
                                stream.quality!.isNotEmpty
                                ? stream.quality!
                                : 'কোয়ালিটি ${index + 1}';

                            return GestureDetector(
                              onTap: () => _switchStream(stream),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : (isDark
                                      ? AppColors.cardDark
                                      : Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : (isDark
                                        ? Colors.white24
                                        : Colors.black12),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    qualityLabel,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark
                                          ? Colors.white
                                          : Colors.black),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const Divider(),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'অন্যান্য বাংলাদেশ চ্যানেলসমূহ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    Text(
                      '${otherChannels.length}টি চ্যানেল',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: otherChannels.length,
                itemBuilder: (context, index) {
                  final ch = otherChannels[index];
                  return ChannelCard(
                    channel: ch,
                    isListStyle: true,
                    onTap: () => _switchChannel(ch),
                    onFavoriteToggle: () => tvViewModel.toggleFavorite(ch),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}