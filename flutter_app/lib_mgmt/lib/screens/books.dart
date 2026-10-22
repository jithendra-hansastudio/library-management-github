import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';

// ==========================================
// 1. BOOKS CATALOG SCREEN (Main List View)
// ==========================================
class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<dynamic>> _booksFuture;
  late Future<Map<String, dynamic>> _designFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
    _designFuture = fetchDesign();
  }

  Future<List<dynamic>> fetchBooks() async {
    final response = await _apiClient.get('/books');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded['data'] is List) return decoded['data'];
      return [];
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchDesign() async {
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
            appBar: AppBar(
              title: const Text('Books Catalog'),
            ),
            body: FutureBuilder<List<dynamic>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading books: ${snapshot.error}'));
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
                          'No books found in the library database.',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                }

                final books = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Books Catalog',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text('Total Titles: ${books.length}'),
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
                              childAspectRatio: 2.2,
                            ),
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              final bookId = book['id'];
                              final bookName = book['book_name'] ?? 'Untitled';
                              final authorName = book['author'] != null
                                  ? book['author']['author_name']
                                  : 'Unknown Author';

                              return InkWell(
                                onTap: () {
                                  if (bookId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(
                                          bookId: bookId,
                                          designSettings: settings, // Pass settings to detail screen
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bookName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Author: $authorName',
                                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
// 2. BOOK DETAIL SCREEN (Individual View)
// ==========================================
class BookDetailScreen extends StatefulWidget {
  final int bookId;
  final Map<String, dynamic> designSettings;

  const BookDetailScreen({
    super.key,
    required this.bookId,
    required this.designSettings,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  Map<String, dynamic>? _bookData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    try {
      final response = await _apiClient.get('/books/${widget.bookId}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _bookData = decoded['data'] ?? decoded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load book details (${response.statusCode})';
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
    final bookName = _bookData?['book_name'] ?? 'Book Details';

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text(bookName)),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Details Card matching the Home Page style
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Book Record',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bookName,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 32),
                      _buildDetailRow(
                        'Author',
                        _bookData?['author']?['author_name'] ?? 'Unknown Author',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Condition',
                        (_bookData?['book_condition'] ?? 'N/A').toString().toUpperCase(),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Year Published',
                        _bookData?['year_of_publishing']?.toString() ?? 'N/A',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Added to Library',
                        _bookData?['created_at']?.toString().split('T')[0] ?? 'N/Key',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Back button styled cleanly
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Books List'),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
