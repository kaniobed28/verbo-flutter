import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/theme_constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? any; // Make this final to comply with @immutable

  const CustomAppBar({super.key, this.any});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80.0); // Implement preferredSize here
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return AppBar(
      toolbarHeight: 80.0, // Adjust the height as needed
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor, // Start color
              Colors.blueAccent, // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Get.toNamed("/");
        },
        child: const Text(
          'Verbo',
          style: TextStyle(
            fontSize: 24, // Adjust title font size
            fontWeight: FontWeight.bold,
            color: Colors.white, // Title text color
          ),
        ),
      ),
      actions: [
        if (widget.any != null) widget.any!, // Add any widget if it's not null
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white), // Icon button
          onPressed: () {
            // Action for info button
            Get.snackbar(
              'Information',
              'This app converts text to audio.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black87,
              colorText: Colors.white,
            );
          },
        ),
        // Theme Toggle Button
        Obx(() => IconButton(
              icon: Icon(
                themeController.isDarkTheme.value
                    ? Icons.wb_sunny
                    : Icons.nights_stay,
                color: Colors.white,
              ),
              onPressed: () {
                themeController.toggleTheme(); // Toggle theme on button press
              },
            )),
        // New Settings Icon
        IconButton(
          icon: const Icon(Icons.assessment, color: Colors.white),
          onPressed: () {
            // Action for settings button
            Get.toNamed('/speak-page'); // Navigate to settings page
          },
        ),
        // New Feedback Icon
        IconButton(
          icon: const Icon(Icons.emoji_events, color: Colors.white),
          onPressed: () {
            // Action for feedback button
            Get.toNamed('/challenge-page'); // Navigate to challenge page
          },
        ),
      ],
    );
  }
}
