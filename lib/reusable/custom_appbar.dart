import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/theme_constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? any;

  const CustomAppBar({super.key, this.any});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return AppBar(
      toolbarHeight: 80.0,
      backgroundColor: Theme.of(context).primaryColor,
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        style: const TextStyle(color: Colors.white),
        onSubmitted: (query) {
          Get.snackbar('Search', 'Searching for "$query"',
              snackPosition: SnackPosition.BOTTOM);
        },
      ),
      actions: [
        if (isSmallScreen) ...[
          PopupMenuButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            itemBuilder: (context) => [
              _popupMenuItem(Icons.home, 'Home', () => Get.toNamed('/')),
              _popupMenuItem(Icons.sports_gymnastics, 'Practice',
                  () => Get.toNamed('/level-practice-page')),
              _popupMenuItem(Icons.assessment, 'Speak', () => Get.toNamed('/speak-page')),
              _popupMenuItem(Icons.emoji_events, 'Challenges',
                  () => Get.toNamed('/challenge-page')),
            ],
          ),
        ] else ...[
          Row(
            children: [
              _navButton(
                icon: Icons.home,
                label: 'Home',
                onTap: () => Get.toNamed('/'),
              ),
              _navButton(
                icon: Icons.sports_gymnastics,
                label: 'Practice',
                onTap: () => Get.toNamed('/level-practice-page'),
              ),
              _navButton(
                icon: Icons.assessment,
                label: 'Speak',
                onTap: () => Get.toNamed('/speak-page'),
              ),
              _navButton(
                icon: Icons.emoji_events,
                label: 'Challenges',
                onTap: () => Get.toNamed('/challenge-page'),
              ),
            ],
          ),
        ],
        const SizedBox(width: 8),
        Obx(() => IconButton(
              icon: Icon(
                themeController.isDarkTheme.value
                    ? Icons.wb_sunny
                    : Icons.nights_stay,
                color: Colors.white,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
            )),
      ],
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  PopupMenuItem _popupMenuItem(
      IconData icon, String text, VoidCallback onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
