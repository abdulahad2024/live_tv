import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tv_viewmodel.dart';
import '../utils/constants.dart';
import 'home/home_screen.dart';
import 'channels/channel_list_screen.dart';
import 'favorites/favorites_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {


  int _currentIndex = 0;
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {


    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tvViewModel = context.watch<TvViewModel>();

    final List<Widget> pages = [
      HomeScreen(
        onSeeAllChannelsTap: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      const ChannelListScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;


          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.exit_to_app_rounded,
                    size: 20,
                    color: isDark ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'বের হতে আবার Back চাপুন',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
              elevation: 6,
              margin: const EdgeInsets.fromLTRB(40, 0, 40, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          );


          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'হোম',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.tv_outlined),
                activeIcon: Icon(Icons.tv_rounded),
                label: 'সব চ্যানেল',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.favorite_border_rounded),
                    if (tvViewModel.favoriteChannels.isNotEmpty)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.favoriteHeart,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${tvViewModel.favoriteChannels.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: const Icon(Icons.favorite_rounded),
                label: 'প্রিয়',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'সেটিংস',
              ),
            ],
          ),
        ),
      ),
    );
  }
}