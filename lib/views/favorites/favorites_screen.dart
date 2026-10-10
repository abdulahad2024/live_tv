import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/tv_viewmodel.dart';
import '../../utils/constants.dart';
import '../../widgets/channel_card.dart';
import '../player/live_player_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _openPlayer(BuildContext context, channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LivePlayerScreen(channel: channel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tvViewModel = context.watch<TvViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteChannels = tvViewModel.favoriteChannels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার প্রিয় চ্যানেলসমূহ'),
        actions: [
          if (favoriteChannels.isNotEmpty)
            IconButton(
              icon: Icon(
                tvViewModel.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              ),
              onPressed: tvViewModel.toggleViewMode,
            ),
        ],
      ),
      body: SafeArea(
        child: favoriteChannels.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.favoriteHeart.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 64,
                          color: AppColors.favoriteHeart,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'কোনো প্রিয় চ্যানেল যুক্ত করা নেই',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'যেকোনো চ্যানেলের ওপর লাভ আইকনে চাপ দিয়ে প্রিয় তালিকায় যুক্ত করুন।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : tvViewModel.isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: favoriteChannels.length,
                    itemBuilder: (context, index) {
                      final channel = favoriteChannels[index];
                      return ChannelCard(
                        channel: channel,
                        onTap: () => _openPlayer(context, channel),
                        onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteChannels.length,
                    itemBuilder: (context, index) {
                      final channel = favoriteChannels[index];
                      return ChannelCard(
                        channel: channel,
                        isListStyle: true,
                        onTap: () => _openPlayer(context, channel),
                        onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                      );
                    },
                  ),
      ),
    );
  }
}
