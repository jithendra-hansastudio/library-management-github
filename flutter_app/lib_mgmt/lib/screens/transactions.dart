import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';

// ==========================================
// 1. TRANSACTIONS LIST SCREEN
// ==========================================
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<dynamic>> _transactionsFuture;
  late Future<Map<String, dynamic>> _designFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
    _designFuture = _fetchDesign();
  }

  Future<List<dynamic>> _fetchTransactions() async {
    final response = await _apiClient.get('/transactions');

    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        return decodedData;
      } else if (decodedData is Map<String, dynamic>) {
        if (decodedData['data'] is List) {
          return decodedData['data'];
        } else if (decodedData['data'] is Map &&
            decodedData['data']['data'] is List) {
          return decodedData['data']['data'];
        }
      }
      return [];
    } else {
      throw Exception('Failed to load transactions: ${response.statusCode}');
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
            appBar: AppBar(
              title: const Text('Transactions Log'),
            ),
            body: FutureBuilder<List<dynamic>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
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
                          'No transaction records found in the library database.',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                }

                final transactions = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Library Transactions Log',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Track active borrowings, returns, and records',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text('Total Logs: ${transactions.length}'),
                            backgroundColor: primaryColor,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // Responsive Cards List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          final txId = tx['id'];
                          final userName = tx['user'] != null
                              ? tx['user']['user_name']
                              : 'Unknown User';
                          final bookName = tx['book'] != null
                              ? tx['book']['book_name']
                              : 'Unknown Book';
                          final status = (tx['status'] ?? 'borrowed').toLowerCase();
                          final issueDate = tx['issue_date'] ?? 'N/A';
                          final returnDate = tx['date_of_return'] ?? tx['due_date'] ?? 'N/A';
                          final finePaid = double.tryParse(tx['total_fine_paid']?.toString() ?? '0') ?? 0.0;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#$txId',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    bookName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Borrower: $userName',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const Divider(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Issue: $issueDate\nDue: $returnDate',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Fine: \$${finePaid.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              foregroundColor: primaryColor,
                                            ),
                                            onPressed: () {
                                              if (txId != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TransactionDetailScreen(
                                                          transactionId: txId,
                                                          designSettings: settings,
                                                        ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Details →'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
// 2. TRANSACTION DETAIL SCREEN
// ==========================================
class TransactionDetailScreen extends StatefulWidget {
  final int transactionId;
  final Map<String, dynamic> designSettings;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
    required this.designSettings,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  Map<String, dynamic>? _txData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTransactionDetails();
  }

  Future<void> _fetchTransactionDetails() async {
    try {
      final response = await _apiClient.get('/transactions/${widget.transactionId}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _txData = decoded['data'] ?? decoded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
          'Failed to load transaction details (${response.statusCode})';
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
    final status = (_txData?['status'] ?? 'borrowed').toLowerCase();

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transaction #${widget.transactionId}'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
            child: Text(_errorMessage!,
                style: const TextStyle(color: Colors.red)))
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Borrow Record',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              border: Border.all(color: primaryColor.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status.toUpperCase(),
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
                        'Transaction Record #${widget.transactionId}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'BORROWER & BOOK INFO',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Borrower',
                        _txData?['user']?['user_name'] ??
                            'Unknown User',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Book Title',
                        _txData?['book']?['book_name'] ??
                            'Unknown Book',
                      ),
                      const Divider(height: 32),
                      const Text(
                        'TIMELINE & FINES',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Issue Date',
                        _txData?['issue_date'] ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Due Date',
                        _txData?['date_of_return'] ??
                            _txData?['due_date'] ??
                            'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Returned On',
                        _txData?['returned_on'] ?? 'Not returned yet',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Fine Paid',
                        '\$${double.tryParse(_txData?['total_fine_paid']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Transactions Log'),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
