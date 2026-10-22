import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';

// ==========================================
// 1. LIBRARY USERS SCREEN (Main List View)
// ==========================================
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
    _designFuture = _fetchDesign();
  }

  Future<List<dynamic>> _fetchUsers() async {
    // FIXED: Changed endpoint from /lib_users to /users matching Laravel routes/api.php
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

  Future<Map<String, dynamic>> _fetchDesign() async {
    final response = await _apiClient.get('/settings');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>) {
          return decoded['data'];
        }
        return decoded;
      }
    }
    return {
      'theme_preset': 'ocean',
      'corner_style': 'smooth',
      'font_scale': 1,
      'is_dark_mode': false,
    };
  }

  ThemeData _buildCustomTheme(Map<String, dynamic> settings) {
    final String presetKey = settings['theme_preset'] ?? 'amber';
    final String cornerKey = settings['corner_style'] ?? 'smooth';
    final double fontScale = double.tryParse(settings['font_scale']?.toString() ?? '1') ?? 1.0;
    final bool isDarkMode = settings['is_dark_mode'] ?? false;

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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _designFuture,
      builder: (context, designSnapshot) {
        final settings = designSnapshot.hasData ? designSnapshot.data! : {
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
            appBar: AppBar(title: const Text('Library Users')),
            body: FutureBuilder<List<dynamic>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'No users found.',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                }

                final users = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Registered Members',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text('Total Users: ${users.length}'),
                            backgroundColor: primaryColor,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth >= 992 ? 3 : (constraints.maxWidth >= 768 ? 2 : 1);

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final userId = user['id'];
                              final userName = user['user_name'] ?? 'Unknown';
                              final role = user['role'] ?? 'member';

                              return InkWell(
                                onTap: () {
                                  if (userId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LibUserDetailScreen(
                                          userId: userId,
                                          designSettings: settings,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: primaryColor.withOpacity(0.15),
                                          child: Text(
                                            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                userName,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Role: ${role.toUpperCase()}',
                                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
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

// ==========================================
// 2. LIBRARY USER DETAIL SCREEN
// ==========================================
class LibUserDetailScreen extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> designSettings;

  const LibUserDetailScreen({
    super.key,
    required this.userId,
    required this.designSettings,
  });

  @override
  State<LibUserDetailScreen> createState() => _LibUserDetailScreenState();
}

class _LibUserDetailScreenState extends State<LibUserDetailScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      // FIXED: Changed endpoint from /lib_users/{id} to /users/{id}
      final response = await _apiClient.get('/users/${widget.userId}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _userData = decoded['data'] ?? decoded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load user profile (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  ThemeData _buildCustomTheme(Map<String, dynamic> settings) {
    final String presetKey = settings['theme_preset'] ?? 'amber';
    final String cornerKey = settings['corner_style'] ?? 'smooth';
    final double fontScale = double.tryParse(settings['font_scale']?.toString() ?? '1') ?? 1.0;
    final bool isDarkMode = settings['is_dark_mode'] ?? false;

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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
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
    final ThemeData customTheme = _buildCustomTheme(widget.designSettings);
    final primaryColor = customTheme.primaryColor;

    final userName = _userData?['user_name'] ?? 'User Profile';
    final role = (_userData?['role'] ?? '').toString().toUpperCase();
    final transactions = _userData?['transactions'] as List? ?? [];
    final donations = _userData?['donations'] as List? ?? [];

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text(userName)),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'User Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (role.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                border: Border.all(color: primaryColor.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                role,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 32),

                      // Transactions History Section
                      const Text(
                        'Transactions History',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      transactions.isEmpty
                          ? const Text('No transactions recorded.')
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          // FIXED: Cleaned up string syntax error here
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              tileColor: Colors.white.withOpacity(0.5),
                              title: Text(
                                'Tx #${tx['id']} - Status: ${(tx['status'] ?? 'N/A').toString().toUpperCase()}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Text('Issued: ${tx['issue_date'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 32),

                      // Donations Section
                      const Text(
                        'Donations',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      donations.isEmpty
                          ? const Text('No donations recorded.')
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: donations.length,
                        itemBuilder: (context, index) {
                          final don = donations[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              tileColor: Colors.white.withOpacity(0.5),
                              title: Text(
                                'Donation Type: ${don['book_type'] ?? 'N/A'}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Text('Quantity: ${don['quantity_of_donations'] ?? '0'}', style: const TextStyle(fontSize: 12)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Users List'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
