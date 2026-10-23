import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import 'show.dart';

class LibUsersScreen extends StatefulWidget {
  const LibUsersScreen({super.key});

  @override
  State<LibUsersScreen> createState() => _LibUsersScreenState();
}

class _LibUsersScreenState extends State<LibUsersScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<dynamic>> _usersFuture;
  late Future<Map<String, dynamic>> _designFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
    _designFuture = ThemeConfig.fetchDesign(_apiClient);
  }

  Future<List<dynamic>> _fetchUsers() async {
    final response = await _apiClient.get('/users');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded['data'] is List) return decoded['data'];
      return [];
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _designFuture,
      builder: (context, designSnapshot) {
        final settings = designSnapshot.hasData
            ? designSnapshot.data!
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
            appBar: AppBar(title: const Text('Library Users')),
            body: FutureBuilder<List<dynamic>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final users = snapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Responsive Page Header matching Laravel Blade
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isMobile = constraints.maxWidth < 600;
                              if (isMobile) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Library Users',
                                      style: TextStyle(
                                          fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Browse and manage registered users and their system roles',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        'Total Users: ${users.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Library Users',
                                        style: TextStyle(
                                            fontSize: 28, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Browse and manage registered users and their system roles',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      'Total Users: ${users.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(thickness: 1),
                          ),
                          users.isEmpty
                              ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFcff4fc),
                              border: Border.all(color: const Color(0xFFb6effb)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'No users found in the system database.',
                              style: TextStyle(color: Color(0xFF055160)),
                            ),
                          )
                              : LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              int crossAxisCount = screenWidth >= 992
                                  ? 3
                                  : (screenWidth >= 768 ? 2 : 1);
                              double spacing = 24.0;
                              double cardWidth =
                                  (screenWidth - (spacing * (crossAxisCount - 1))) /
                                      crossAxisCount;

                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: users.map((libUser) {
                                  final userId = libUser['id'];
                                  final userName =
                                      libUser['user_name'] ?? 'Untitled';
                                  final gender =
                                  (libUser['gender'] ?? 'N/A').toString().toUpperCase();
                                  final role =
                                  (libUser['role'] ?? 'N/A').toString();
                                  final formattedRole = role.isNotEmpty
                                      ? role[0].toUpperCase() + role.substring(1)
                                      : 'N/A';

                                  return SizedBox(
                                    width: cardWidth,
                                    child: InkWell(
                                      onTap: userId != null
                                          ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LibUserDetailScreen(
                                                  userId: userId,
                                                  designSettings: settings,
                                                ),
                                          ),
                                        );
                                      }
                                          : null,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      userName,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade600,
                                                      borderRadius:
                                                      BorderRadius.circular(50),
                                                    ),
                                                    child: Text(
                                                      formattedRole,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'Gender: $gender',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600),
                                              ),
                                              const SizedBox(height: 24),
                                              Container(
                                                padding: const EdgeInsets.only(top: 12),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: Colors.grey.shade200),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Click to view full user profile & history \u2192',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
