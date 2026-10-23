import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import '../books/show.dart';

class AuthorDetailScreen extends StatefulWidget {
  final int authorId;
  final Map<String, dynamic> designSettings;

  const AuthorDetailScreen({
    super.key,
    required this.authorId,
    required this.designSettings,
  });

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  Map<String, dynamic>? _authorData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final response = await _apiClient.get('/authors/${widget.authorId}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _authorData = decoded['data'] ?? decoded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load author details (${response.statusCode})';
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

  @override
  Widget build(BuildContext context) {
    final ThemeData customTheme = ThemeConfig.buildTheme(widget.designSettings);
    final primaryColor = customTheme.colorScheme.primary;

    final authorName = _authorData?['author_name'] ?? 'Author Profile';
    final books = _authorData?['books'] as List? ?? [];
    final bookLabel = books.length == 1 ? 'Book' : 'Books';

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('$authorName - Author Profile')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Navigation Button
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('\u2190 Back to Authors List'),
                  ),
                  const SizedBox(height: 24),

                  // Author Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUTHOR PROFILE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authorName,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '${books.length} Published $bookLabel',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Books Written Section Header
                  const Text(
                    'Books Written',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(thickness: 1),
                  ),

                  books.isEmpty
                      ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFcff4fc),
                      border: Border.all(color: const Color(0xFFb6effb)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'This author currently has no registered books in the library.',
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
                        children: books.map((authorBook) {
                          final bookId = authorBook['id'];
                          final bookName = authorBook['book_name'] ?? 'Untitled';
                          final year = authorBook['year_of_publishing'] ?? 'N/A';
                          final condition = (authorBook['book_condition'] ?? 'N/A').toString();
                          final formattedCondition = condition.isNotEmpty
                              ? condition[0].toUpperCase() + condition.substring(1)
                              : 'N/A';

                          return SizedBox(
                            width: cardWidth,
                            child: InkWell(
                              onTap: bookId != null
                                  ? () {
                                // TODO: Navigate to Book Detail screen when ready
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailScreen(
                                      bookId: bookId,
                                      designSettings: widget.designSettings,
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
                                      Text(
                                        bookName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        padding: const EdgeInsets.only(top: 12),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Year: $year',
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade600,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                formattedCondition,
                                                style: const TextStyle(color: Colors.white, fontSize: 11),
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
        ),
      ),
    );
  }
}
