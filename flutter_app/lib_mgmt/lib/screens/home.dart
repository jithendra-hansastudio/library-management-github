import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lib_mgmt_task/screens/authors/index.dart';
import 'package:lib_mgmt_task/screens/lib_users/index.dart';
import 'package:lib_mgmt_task/screens/transactions/index.dart';
import 'package:lib_mgmt_task/services/auth_services.dart';
import 'package:lib_mgmt_task/services/theme_config.dart';
import '../services/api_client.dart';
import 'books/index.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> _designFuture;
  final AuthService _authService = AuthService();
  String role = "not Deco";

  @override
  void initState() {
    super.initState();
    _designFuture = ThemeConfig.fetchDesign(ApiClient());
    loadUser();
  }

  void loadUser() async {
    role = await _authService.getUserRole();
    if (mounted) {
      setState(() {});
    }
  }

  void _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _designFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final settings = snapshot.hasData
            ? snapshot.data!
            : {
          'theme_preset': 'ocean',
          'corner_style': 'smooth',
          'font_scale': 1.0,
          'is_dark_mode': false,
        };

        final ThemeData customTheme = ThemeConfig.buildTheme(settings);
        final primaryColor = customTheme.colorScheme.primary;

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
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section Card
                      Card(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const TransactionsScreen(),
                                        ),
                                      );
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

                      // Grid Cards using Wrap for responsive safety
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          int crossAxisCount = screenWidth >= 1200
                              ? 4
                              : (screenWidth >= 800 ? 2 : 1);
                          double spacing = 16.0;
                          double cardWidth =
                              (screenWidth - (spacing * (crossAxisCount - 1))) /
                                  crossAxisCount;

                          final List<Widget> directoryCards = [
                            _buildDirectoryCard(
                              badgeText: 'Catalog',
                              title: 'Books Catalog',
                              description:
                              'Explore available book titles, availability, and condition reports.',
                              buttonText: 'Go to Books Catalog →',
                              primaryColor: primaryColor,
                              cardWidth: cardWidth,
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
                              cardWidth: cardWidth,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthorsScreen(),
                                  ),
                                );
                              },
                            ),
                            if (role == 'librarian' || role == 'admin')
                              _buildDirectoryCard(
                                badgeText: 'Members',
                                title: 'Library Users',
                                description:
                                'Manage members, librarians, and administrative user profiles.',
                                buttonText: 'Go to Users →',
                                primaryColor: primaryColor,
                                cardWidth: cardWidth,
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
                              cardWidth: cardWidth,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TransactionsScreen(),
                                  ),
                                );
                              },
                            ),
                          ];

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: directoryCards,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
    required double cardWidth,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                    style: TextStyle(color: primaryColor, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
