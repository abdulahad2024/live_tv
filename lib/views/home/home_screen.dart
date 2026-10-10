import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/tv_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/hero_carousel.dart';
import '../../widgets/channel_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../player/live_player_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onSeeAllChannelsTap;

  const HomeScreen({
    super.key,
    required this.onSeeAllChannelsTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
    final themeViewModel = context.watch<ThemeViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: tvViewModel.refreshChannels,
          color: AppColors.primaryLight,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [


                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.live_tv_rounded,
                          color: AppColors.primaryLight,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textDark : AppColors.textLight,
                              ),
                            ),
                            Text(
                              AppConstants.appSubtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          themeViewModel.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: isDark ? AppColors.goldAccent : Colors.indigo,
                        ),
                        onPressed: themeViewModel.toggleTheme,
                      ),


                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomSearchBar(
                    hintText: 'চ্যানেলের নাম দিয়ে খুঁজুন...',
                    controller: _searchController,
                    onChanged: tvViewModel.setSearchQuery,
                    onClear: () {
                      _searchController.clear();
                      tvViewModel.setSearchQuery('');
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              if (tvViewModel.isLoading)
                const SliverFillRemaining(
                  child: CustomLoadingWidget(message: 'লাইভ চ্যানেল লোড হচ্ছে...'),
                )
              else if (tvViewModel.errorMessage != null)
                SliverFillRemaining(
                  child: CustomErrorWidget(
                    errorMessage: tvViewModel.errorMessage!,
                    onRetry: tvViewModel.refreshChannels,
                  ),
                )
              else ...[
                if (tvViewModel.searchQuery.isEmpty && tvViewModel.selectedCategory == 'all') ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: HeroCarousel(
                        featuredChannels: tvViewModel.featuredChannels,
                        onChannelTap: (channel) => _openPlayer(context, channel),
                      ),
                    ),
                  ),
                ],

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
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
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Favorites Quick Horizontal Bar (If user has favorites)
                if (tvViewModel.favoriteChannels.isNotEmpty &&
                    tvViewModel.searchQuery.isEmpty &&
                    tvViewModel.selectedCategory == 'all') ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_rounded, color: AppColors.favoriteHeart, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'আপনার প্রিয় চ্যানেলসমূহ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textDark : AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: tvViewModel.favoriteChannels.length,
                        itemBuilder: (context, index) {
                          final channel = tvViewModel.favoriteChannels[index];
                          return SizedBox(
                            width: 140,
                            child: ChannelCard(
                              channel: channel,
                              horizontalMargin: 6,
                              onTap: () => _openPlayer(context, channel),
                              onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tvViewModel.selectedCategory == 'all'
                              ? 'সকল বাংলাদেশ লাইভ চ্যানেল (${tvViewModel.filteredChannels.length})'
                              : '${AppConstants.categoryTranslations[tvViewModel.selectedCategory] ?? tvViewModel.selectedCategory} (${tvViewModel.filteredChannels.length})',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onSeeAllChannelsTap,
                          child: const Text(
                            'সব দেখুন',
                            style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (tvViewModel.filteredChannels.isEmpty)
                  SliverToBoxAdapter(
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
                            'কোন চ্যানেল পাওয়া যায়নি',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'অন্য কোনো নাম বা ক্যাটাগরি দিয়ে খুঁজে দেখুন।',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final channel = tvViewModel.filteredChannels[index];
                          return ChannelCard(
                            channel: channel,
                            onTap: () => _openPlayer(context, channel),
                            onFavoriteToggle: () => tvViewModel.toggleFavorite(channel),
                          );
                        },
                        childCount: tvViewModel.filteredChannels.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
