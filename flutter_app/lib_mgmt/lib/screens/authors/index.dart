import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import 'show.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  final ApiClient _apiClient = ApiClient();
  late final Future<List<dynamic>> _authorsFuture = _fetchAuthors();

  Future<List<dynamic>> _fetchAuthors() async {
    final response = await _apiClient.get('/authors');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded['data'] is List) return decoded['data'];
      return [];
    }
    throw Exception('Failed to load authors: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ThemeConfig.fetchDesign(_apiClient),
      builder: (context, designSnapshot) {
        final settings = designSnapshot.data ?? {};
        final ThemeData customTheme = ThemeConfig.buildTheme(settings);
        final primaryColor = customTheme.colorScheme.primary;

        return Theme(
          data: customTheme,
          child: Scaffold(
            appBar: AppBar(title: const Text('Library Management Dashboard')),
            body: FutureBuilder<List<dynamic>>(
              future: _authorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final authors = snapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page Header (Wrapped for mobile safety)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isMobile = constraints.maxWidth < 600;
                              if (isMobile) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Authors Directory',
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Browse all registered authors and their published titles',
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Total Authors: ${authors.length}',
                                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
                                        'Authors Directory',
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Browse all registered authors and their published titles',
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Total Authors: ${authors.length}',
                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
                          authors.isEmpty
                              ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFcff4fc),
                              border: Border.all(color: const Color(0xFFb6effb)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'No authors found in the system database.',
                              style: TextStyle(color: Color(0xFF055160)),
                            ),
                          )
                              : LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              int crossAxisCount = screenWidth >= 992 ? 3 : (screenWidth >= 768 ? 2 : 1);
                              double spacing = 24.0;
                              double cardWidth = (screenWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: authors.map((author) {
                                  final authorId = author['id'];
                                  final authorName = author['author_name'] ?? 'Unknown Author';

                                  final booksList = author['books'] as List?;
                                  final booksCount = author['books_count'] ?? (booksList?.length ?? 0);
                                  final bookLabel = booksCount == 1 ? 'Book' : 'Books';

                                  return SizedBox(
                                    width: cardWidth,
                                    child: InkWell(
                                      onTap: authorId != null
                                          ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AuthorDetailScreen(
                                              authorId: authorId,
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      authorName,
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
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade600,
                                                      borderRadius: BorderRadius.circular(50),
                                                    ),
                                                    child: Text(
                                                      '$booksCount $bookLabel',
                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              Text(
                                                'Click to view author profile & published books \u2192',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
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
