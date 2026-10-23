import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import 'show.dart';

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
    _designFuture = ThemeConfig.fetchDesign(_apiClient);
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
            appBar: AppBar(
              title: const Text('Transaction Log - Library Management'),
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
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }

                final transactions = snapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page Header
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isMobile = constraints.maxWidth < 600;
                              if (isMobile) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Library Transactions Log',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Track active borrowings, returns, and transaction records',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Total Logs: ${transactions.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Library Transactions Log',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Track active borrowings, returns, and transaction records',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Total Logs: ${transactions.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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

                          // Content Body
                          transactions.isEmpty
                              ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  'No transaction records found in the library database.',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final tx = transactions[index];
                              final txId = tx['id'];
                              final user = tx['user'];
                              final book = tx['book'];
                              final userName = user?['user_name'] ?? 'Unknown User';
                              final bookName = book?['book_name'] ?? 'Unknown Book';
                              final status = (tx['status'] ?? 'borrowed').toLowerCase();
                              final dueDate = tx['date_of_return'] ?? tx['due_date'] ?? 'N/A';
                              final finePaid = double.tryParse(tx['total_fine_paid']?.toString() ?? '0') ?? 0.0;

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isMobile = constraints.maxWidth < 600;

                                  // Mobile View: Stacked Card Layout
                                  if (isMobile) {
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
                                                  '#${txId ?? '-'}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: status == 'borrowed'
                                                        ? Colors.grey.shade600
                                                        : primaryColor,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    status == 'borrowed' ? 'Borrowed' : 'Returned',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              bookName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Borrower: $userName',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              child: Divider(height: 1),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Due: $dueDate',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                OutlinedButton(
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
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(color: primaryColor),
                                                    foregroundColor: primaryColor,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 6),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6)),
                                                  ),
                                                  child: const Text('Details →', style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Desktop/Tablet View: Table Row Card Layout
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              '#${txId ?? '-'}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bookName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Borrower: $userName',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: status == 'borrowed'
                                                  ? Colors.grey.shade600
                                                  : primaryColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              status == 'borrowed' ? 'Borrowed' : 'Returned',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              'Due: $dueDate',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          OutlinedButton(
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
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: primaryColor),
                                              foregroundColor: primaryColor,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6)),
                                            ),
                                            child: const Text('Details →', style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
