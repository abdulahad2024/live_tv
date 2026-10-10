import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel_model.dart';
import '../utils/constants.dart';

class ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isListStyle;

  /// Same channel different screen e thakle Hero conflict hobe.
  /// Tai alada prefix den (e.g. 'home', 'fav').
  final String heroTagPrefix;

  /// Horizontal list e card'er dui pashe fanka dite (e.g. 6).
  final double horizontalMargin;

  const ChannelCard({
    super.key,
    required this.channel,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isListStyle = false,
    this.heroTagPrefix = 'logo',
    this.horizontalMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isListStyle) {
      return _buildListTile(context, isDark);
    }

    return _buildGridCard(context, isDark);
  }

  Widget _buildGridCard(BuildContext context, bool isDark) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: channel.hasActiveStream
                ? (isDark
                ? AppColors.primaryDark.withValues(alpha: 0.3)
                : AppColors.primaryLight.withValues(alpha: 0.3))
                : (isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05)),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Category badge & Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category Badge
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDark.withValues(alpha: 0.15)
                              : AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          channel.categoryBanglaName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.primaryDark
                                : AppColors.primaryVariantLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Favorite Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onFavoriteToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: channel.isFavorite
                              ? AppColors.favoriteHeart.withValues(alpha: 0.15)
                              : (isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.05)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          channel.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: channel.isFavorite
                              ? AppColors.favoriteHeart
                              : (isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight),
                        ),
                      ),
                    ),
                  ],
                ),

                // Channel Logo (card'er height onujayi auto size)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double logoSize =
                      constraints.maxHeight.clamp(32.0, 80.0).toDouble();
                      return Center(
                        child: Hero(
                          tag: '${heroTagPrefix}_${channel.id}',
                          child: _buildLogoWidget(logoSize, logoSize),
                        ),
                      );
                    },
                  ),
                ),

                // Channel Name
                Text(
                  channel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),

                // Live / Offline row
                Row(
                  children: [
                    if (channel.hasActiveStream) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.liveBadge,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'লাইভ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.liveBadge,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${channel.streams.length} স্ট্রিম',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.signal_cellular_off_rounded,
                        size: 12,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'অফলাইন',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, bool isDark) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 5,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo Container
            Hero(
              tag: '${heroTagPrefix}_${channel.id}',
              child: _buildLogoWidget(54, 54),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                      if (channel.hasActiveStream)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.liveBadge.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fiber_manual_record,
                                  size: 8, color: AppColors.liveBadge),
                              SizedBox(width: 4),
                              Text(
                                'লাইভ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.liveBadge,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        channel.categoryBanglaName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryVariantLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (channel.network != null &&
                          channel.network!.isNotEmpty)
                        Flexible(
                          child: Text(
                            ' • ${channel.network}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite button
            IconButton(
              icon: Icon(
                channel.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: channel.isFavorite
                    ? AppColors.favoriteHeart
                    : (isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight),
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWidget(double width, double height) {
    if (channel.logoUrl != null && channel.logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: channel.logoUrl!,
          width: width,
          height: height,
          fit: BoxFit.contain,
          memCacheWidth: (width * 3).toInt(),
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              _buildFallbackLogo(width, height),
        ),
      );
    }
    return _buildFallbackLogo(width, height);
  }

  Widget _buildFallbackLogo(double width, double height) {
    final firstLetter =
    channel.name.isNotEmpty ? channel.name[0].toUpperCase() : 'T';
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryLight,
            AppColors.secondaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            fontSize: width * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}