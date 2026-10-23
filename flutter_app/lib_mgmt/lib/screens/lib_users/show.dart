import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/theme_config.dart';
import '../books/show.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData customTheme = ThemeConfig.buildTheme(widget.designSettings);
    final primaryColor = customTheme.colorScheme.primary;

    final userName = _userData?['user_name'] ?? 'User Profile';
    final role = (_userData?['role'] ?? '').toString();
    final formattedRole = role.isNotEmpty
        ? role[0].toUpperCase() + role.substring(1)
        : 'N/A';
    final gender = (_userData?['gender'] ?? 'N/A').toString().toUpperCase();
    final dob = _userData?['date_of_birth'] ?? 'N/A';
    final address = _userData?['address'] ?? 'N/A';
    final createdAt = _userData?['created_at'] ?? 'N/A';

    final transactions = _userData?['transactions'] as List? ?? [];

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('$userName - User Profile')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(
            child: Text(_errorMessage!,
                style: const TextStyle(color: Colors.red)))
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('\u2190 Back to Users List'),
                  ),
                  const SizedBox(height: 24),

                  // Profile Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  formattedRole,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isWide = constraints.maxWidth >= 768;
                              Widget personalInfoBox = Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.01),
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PERSONAL DETAILS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Gender',
                                            style: TextStyle(
                                                color: Colors.grey.shade600)),
                                        Text(gender,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Date of Birth',
                                            style: TextStyle(
                                                color: Colors.grey.shade600)),
                                        Text(dob,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                ),
                              );

                              Widget accountInfoBox = Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.01),
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ACCOUNT INFORMATION',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Address',
                                            style: TextStyle(
                                                color: Colors.grey.shade600)),
                                        Expanded(
                                          child: Text(
                                            address,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Member Since',
                                            style: TextStyle(
                                                color: Colors.grey.shade600)),
                                        Text(createdAt,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                ),
                              );

                              if (isWide) {
                                return Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: personalInfoBox),
                                    const SizedBox(width: 16),
                                    Expanded(child: accountInfoBox),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    personalInfoBox,
                                    const SizedBox(height: 16),
                                    accountInfoBox,
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Borrowing History Header
                  const Text(
                    'Borrowing History',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(thickness: 1),
                  ),

                  transactions.isEmpty
                      ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFcff4fc),
                      border: Border.all(
                          color: const Color(0xFFb6effb)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'No transaction history found for this user.',
                      style: TextStyle(color: Color(0xFF055160)),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final book = transaction['book'];
                      final bookId = book?['id'];
                      final bookName =
                          book?['book_name'] ?? 'Unknown Book';
                      final status = (transaction['status'] ?? 'N/A')
                          .toString();
                      final isBorrowed =
                          status.toLowerCase() == 'borrowed';
                      final issueDate =
                          transaction['issue_date'] ?? 'N/A';
                      final dueDate = transaction['due_date'] ??
                          transaction['date_of_return'] ??
                          'N/A';
                      final returnedOn =
                          transaction['returned_on'] ?? '—';
                      final finePaid = double.tryParse(transaction[
                      'total_fine_paid']
                          ?.toString() ??
                          '0') ??
                          0.0;

                      return Card(
                        margin:
                        const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: bookId != null
                                          ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookDetailScreen(
                                                  bookId: bookId,
                                                  designSettings:
                                                  widget.designSettings,
                                                ),
                                          ),
                                        );
                                      }
                                          : null,
                                      child: Text(
                                        bookName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isBorrowed
                                          ? Colors.amber.shade300
                                          : Colors.green.shade600,
                                      borderRadius:
                                      BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isBorrowed
                                          ? 'Borrowed'
                                          : 'Returned',
                                      style: TextStyle(
                                        color: isBorrowed
                                            ? Colors.black87
                                            : Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Issue Date',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey.shade600)),
                                  Text(issueDate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Due Date',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey.shade600)),
                                  Text(dueDate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Returned On',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey.shade600)),
                                  Text(returnedOn,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Fine Paid',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey.shade600)),
                                  finePaid > 0
                                      ? Container(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                        horizontal: 6,
                                        vertical: 2),
                                    decoration:
                                    BoxDecoration(
                                      color: Colors
                                          .red.shade600,
                                      borderRadius:
                                      BorderRadius
                                          .circular(4),
                                    ),
                                    child: Text(
                                      '\$${finePaid.toStringAsFixed(2)}',
                                      style:
                                      const TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  )
                                      : Text(
                                    '\$0.00',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors
                                            .grey.shade600),
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
            ),
          ),
        ),
      ),
    );
  }
}
