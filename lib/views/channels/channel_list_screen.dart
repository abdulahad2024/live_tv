import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/tv_viewmodel.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/channel_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../player/live_player_screen.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key});

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('সব বাংলাদেশ টিভি চ্যানেল'),
        actions: [
          IconButton(
            icon: Icon(
              tvViewModel.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: tvViewModel.toggleViewMode,
            tooltip: tvViewModel.isGridView ? 'লিস্ট ভিউ' : 'গ্রিড ভিউ',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomSearchBar(
                hintText: 'চ্যানেল খুঁজুন...',
                controller: _searchController,
                onChanged: tvViewModel.setSearchQuery,
                onClear: () {
                  _searchController.clear();
                  tvViewModel.setSearchQuery('');
                },
              ),
            ),

            SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tvViewModel.availableCategories.length,
                itemBuilder: (context, index) {
                  final catKey = tvViewModel.availableCategories[index];
                  final isSelected = tvViewModel.selectedCategory == catKey;
                  return CategoryChip(
                    categoryKey: catKey,
                    isSelected: isSelected,
                    onTap: () => tvViewModel.setCategory(catKey),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: tvViewModel.isLoading
                  ? const CustomLoadingWidget(message: 'চ্যানেল লোড করা হচ্ছে...')
                  : tvViewModel.errorMessage != null
                      ? CustomErrorWidget(
                          errorMessage: tvViewModel.errorMessage!,
                          onRetry: tvViewModel.refreshChannels,
                        )
                      : tvViewModel.filteredChannels.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 64,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'কোন চ্যানেল মেলেনি',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.textDark : AppColors.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'আপনার অনুসন্ধানের সাথে কোনো বাংলাদেশ চ্যানেল মিলেনি।',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
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
                                  itemCount: tvViewModel.filteredChannels.length,
                                  itemBuilder: (context, index) {
                                    final channel = tvViewModel.filteredChannels[index];
                                    return ChannelCard(
                                      channel: channel,
                                      onTap: () => _openPlayer(context, channel),
                                      onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: tvViewModel.filteredChannels.length,
                                  itemBuilder: (context, index) {
                                    final channel = tvViewModel.filteredChannels[index];
                                    return ChannelCard(
                                      channel: channel,
                                      isListStyle: true,
                                      onTap: () => _openPlayer(context, channel),
                                      onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
    );
  }
}
