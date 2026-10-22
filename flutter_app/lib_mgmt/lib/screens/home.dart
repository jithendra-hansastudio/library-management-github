import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lib_mgmt_task/screens/authors.dart';
import 'package:lib_mgmt_task/screens/lib_users.dart';
import 'package:lib_mgmt_task/screens/transactions.dart';

import '../main.dart';
import '../services/auth_services.dart';
import 'books.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late Future<List<dynamic>> _designFuture;
  late Future<Map<String, dynamic>> _designFuture;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _designFuture = fetchDesign();
  }

  void _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  // Theme builder mapping your web configuration presets
  ThemeData _buildCustomTheme(Map<String, dynamic> settings) {
    final String presetKey = settings['theme_preset'] ?? 'amber';
    final String cornerKey = settings['corner_style'] ?? 'smooth';
    final double fontScale = double.tryParse(settings['font_scale']?.toString() ?? '1') ?? 1.0;
    final bool isDarkMode = settings['is_dark_mode'] ?? false;

    // Web preset color mapping
    const Map<String, Color> primaryColors = {
      'ocean': Color(0xFF0d6efd),
      'emerald': Color(0xFF059669),
      'sunset': Color(0xFF7c3aed),
      'slate': Color(0xFF334155),
      'amber': Color(0xFFd97706),
      'cyber': Color(0xFF06b6d4),
    };

    const Map<String, Color> bgColors = {
      'ocean': Color(0xFFf4f6f9),
      'emerald': Color(0xFFf0fdf4),
      'sunset': Color(0xFFfaf5ff),
      'slate': Color(0xFFf8fafc),
      'amber': Color(0xFFfffbeb),
      'cyber': Color(0xFFecfeff),
    };

    final primaryColor = primaryColors[presetKey] ?? const Color(0xFFd97706);
    final backgroundColor = bgColors[presetKey] ?? const Color(0xFFfffbeb);

    // Corner radius mapping (matches your cornerRadii config)
    double radiusValue = 10.0;
    if (cornerKey == 'sharp') radiusValue = 0.0;
    if (cornerKey == 'pill') radiusValue = 30.0;

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusValue),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusValue),
          ),
        ),
      ),
      textTheme: Typography.material2021().black.apply(
        fontSizeFactor: fontScale,
        bodyColor: isDarkMode ? Colors.white70 : const Color(0xFF212529),
        displayColor: isDarkMode ? Colors.white : const Color(0xFF212529),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 2 : 1);

    return FutureBuilder<Map<String, dynamic>>( // Changed type here
      future: _designFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Fallback to default ocean settings if an error occurs
        final settings = snapshot.hasData ? snapshot.data! : {
          'theme_preset': 'ocean',
          'corner_style': 'smooth',
          'font_scale': 1,
          'is_dark_mode': false,
        };

        final ThemeData customTheme = _buildCustomTheme(settings);
        final primaryColor = customTheme.primaryColor;

        return Theme(
          data: customTheme,
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _handleLogout,
                  tooltip: 'Logout',
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                // Hero Section (matches HTML card with border & padding)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      settings['corner_style'] == 'sharp'
                          ? 0
                          : (settings['corner_style'] == 'pill' ? 30 : 12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Library Portal',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Library Management System',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Welcome to the central library dashboard. Easily browse books, manage registered members, inspect author catalog, and track active borrowings.',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BooksScreen(),
                                  ),
                                );
                              },
                              child: const Text('Browse Books →'),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              onPressed: () {
                                // Navigate to Transactions
                              },
                              child: const Text('View Transactions',
                                  style: TextStyle(color: Colors.black87)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Section Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Directories',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                  ],
                ),
                const SizedBox(height: 20),

                // Grid Cards (Matching HTML row-cols and card styling)
                GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  children: [
                    _buildDirectoryCard(
                      badgeText: 'Catalog',
                      title: 'Books Catalog',
                      description:
                      'Explore available book titles, availability, and condition reports.',
                      buttonText: 'Go to Books Catalog →',
                      primaryColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BooksScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDirectoryCard(
                      badgeText: 'Directory',
                      title: 'Authors Directory',
                      description:
                      'Browse author profiles, bio details, and total published works.',
                      buttonText: 'Go to Authors →',
                      primaryColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthorsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDirectoryCard(
                      badgeText: 'Members',
                      title: 'Library Users',
                      description:
                      'Manage members, librarians, and administrative user profiles.',
                      buttonText: 'Go to Users →',
                      primaryColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LibUsersScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDirectoryCard(
                      badgeText: 'Records',
                      title: 'Transaction Log',
                      description:
                      'Review borrowing activities, return histories, and fine records.',
                      buttonText: 'Go to Transactions →',
                      primaryColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDirectoryCard({
    required String badgeText,
    required String title,
    required String description,
    required String buttonText,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Matches HTML bg-primary-subtle and text-primary styling
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: onTap,
              child: Text(buttonText,
                  style: TextStyle(
                      color: primaryColor, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
