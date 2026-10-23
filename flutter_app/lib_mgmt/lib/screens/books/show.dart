import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import '../transactions/show.dart';
import '../authors/show.dart';

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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
    } catch (_) {
      return dateStr.split('T')[0];
    }
  }

  String _diffForHumans(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} years ago';
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      return 'Just now';
    } catch (_) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData customTheme = ThemeConfig.buildTheme(widget.designSettings);
    final primaryColor = customTheme.colorScheme.primary;
    final bookName = _bookData?['book_name'] ?? 'Book Details';

    final List<dynamic> transactions = _bookData?['transactions'] ?? [];
    final activeBorrowings = transactions.where((t) => t['status'] == 'borrowed').toList();

    final extraCopy = _bookData?['extra_copy'] ?? _bookData?['extraCopy'];
    int totalCopies = 1;
    if (extraCopy != null) {
      final count = int.tryParse(extraCopy['count_of_books']?.toString() ?? '0') ?? 0;
      totalCopies = count + 1;
    }

    final authorData = _bookData?['author'];
    final authorName = authorData?['author_name'] ?? 'Unknown Author';
    final authorId = authorData?['id'];

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text(bookName)),
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
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Books List'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    bookName,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Author: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: authorId != null
                                  ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AuthorDetailScreen(
                                      authorId: authorId,
                                      designSettings: widget.designSettings,
                                    ),
                                  ),
                                );
                              }
                                  : null,
                              child: Text(
                                authorName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: authorId != null ? primaryColor : Colors.black87,
                                  decoration: authorId != null ? TextDecoration.underline : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildBulletDetail('Condition', (_bookData?['book_condition'] ?? 'N/A').toString().toUpperCase()),
                      const SizedBox(height: 12),
                      _buildBulletDetail('Year Published', _bookData?['year_of_publishing']?.toString() ?? 'N/A'),
                      const SizedBox(height: 12),
                      _buildBulletDetail('Added to Library', _formatDate(_bookData?['created_at']?.toString())),
                      const SizedBox(height: 12),
                      _buildBulletDetail('Last Updated', _diffForHumans(_bookData?['updated_at']?.toString())),
                      const SizedBox(height: 12),
                      _buildBulletDetail('Total Available Copies', totalCopies.toString()),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(thickness: 1),
                  ),
                  if (activeBorrowings.isNotEmpty) ...[
                    const Text(
                      'Currently Borrowed:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeBorrowings.length,
                      itemBuilder: (context, index) {
                        final transaction = activeBorrowings[index];
                        final txId = transaction['id'];
                        final dueDate = transaction['date_of_return'] ?? 'N/A';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: txId != null
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(
                                    transactionId: txId,
                                    designSettings: widget.designSettings,
                                  ),
                                ),
                              );
                            }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: customTheme.textTheme.bodyMedium?.color ?? Colors.black87,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Book borrowed with '),
                                          TextSpan(
                                            text: 'Transaction #$txId',
                                            style: TextStyle(
                                              color: primaryColor,
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(text: ' (Due on: $dueDate)'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Text(
                      'This book is currently not borrowed by anyone.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
