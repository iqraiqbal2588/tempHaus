import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/TransctionScreen/Widget/transction_card.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        title: Text(
          "Transaction History",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No transactions found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                // Extract and format transaction data
                final officeName = data['from'] ?? 'Dental Office';
                final professionalName = data['to'] ?? 'Dental Professional';
                final date = _formatDate(data['date']);
                final hourlyWage = data['hourlyWage']?.toString() ?? '0';
                final transactionId = data['transactionId'] ?? '';

                return TransactionCard(
                  image: "assets/Icons/transactionDetail.svg",
                  title: "Invite from $officeName",
                  description: "To: $professionalName\nDate: $date",
                  price: "\$$hourlyWage/hour",
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.transactionDetail,
                      arguments: {
                        'officeName': officeName,
                        'professionalName': professionalName,
                        'date': date,
                        'hourlyWage': hourlyWage,
                        'transactionId': transactionId,
                        'formattedAmount': "\$$hourlyWage/hour",
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';

    try {
      if (date is Timestamp) {
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date.toDate());
      } else if (date is String) {
        // Handle string dates if needed
        final parsedDate = DateTime.tryParse(date);
        if (parsedDate != null) {
          return DateFormat('MMM dd, yyyy - hh:mm a').format(parsedDate);
        }
      }
      return DateFormat('MMM dd, yyyy').format(DateTime.now());
    } catch (e) {
      return 'Invalid date';
    }
  }
}