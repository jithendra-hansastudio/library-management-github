import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';

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
      final response =
      await _apiClient.get('/transactions/${widget.transactionId}');
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

  @override
  Widget build(BuildContext context) {
    final ThemeData customTheme = ThemeConfig.buildTheme(widget.designSettings);
    final primaryColor = customTheme.colorScheme.primary;
    final status = (_txData?['status'] ?? 'borrowed').toLowerCase();

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transaction #${widget.transactionId} Details'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
            child: Text(_errorMessage!,
                style: const TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('← Back to Transactions Log'),
                  ),
                  const SizedBox(height: 24),

                  // Main Transaction Container Card
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction Record #${widget.transactionId}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: status == 'borrowed'
                                      ? Colors.grey.shade600
                                      : primaryColor,
                                  borderRadius:
                                  BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status == 'borrowed'
                                      ? 'Borrowed'
                                      : 'Returned',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Card Body
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              LayoutBuilder(
                                  builder: (context, constraints) {
                                    bool isWide =
                                        constraints.maxWidth >= 768;
                                    final borrowerBox = _buildInfoBox(
                                      title: 'Borrower & Book Info',
                                      children: [
                                        _buildDetailRow(
                                          'Borrower',
                                          _txData?['user']?['user_name'] ??
                                              'Unknown User',
                                          primaryColor,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildDetailRow(
                                          'Book Title',
                                          _txData?['book']?['book_name'] ??
                                              'Unknown Book',
                                          primaryColor,
                                        ),
                                      ],
                                    );

                                    final timelineBox = _buildInfoBox(
                                      title: 'Timeline & Fines',
                                      children: [
                                        _buildDetailRow(
                                          'Issue Date',
                                          _txData?['issue_date'] ?? 'N/A',
                                          null,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildDetailRow(
                                          'Due Date',
                                          _txData?['date_of_return'] ??
                                              _txData?['due_date'] ??
                                              'N/A',
                                          null,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildDetailRow(
                                          'Returned On',
                                          _txData?['returned_on'] ??
                                              'Not returned yet',
                                          null,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildDetailRow(
                                          'Fine Paid',
                                          '\$${double.tryParse(_txData?['total_fine_paid']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                          null,
                                        ),
                                      ],
                                    );

                                    if (isWide) {
                                      return Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: borrowerBox),
                                          const SizedBox(width: 24),
                                          Expanded(child: timelineBox),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          borrowerBox,
                                          const SizedBox(height: 16),
                                          timelineBox,
                                        ],
                                      );
                                    }
                                  }),

                              const SizedBox(height: 32),
                              const Divider(thickness: 1),
                              const SizedBox(height: 12),

                              // Footer Record Date
                              Text(
                                'Record Created: ${_txData?['created_at'] ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.01),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }


  Widget _buildDetailRow(String label, String value, Color? linkColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: linkColor,
            ),
          ),
        ),
      ],
    );
  }
}
