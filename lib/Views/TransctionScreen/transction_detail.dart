import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Views/TransctionScreen/Widget/transction_detail_widget.dart';

class TransactionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionData = Get.arguments as Map<String, dynamic>? ?? {};

    // Extract and format data with proper fallbacks
    final from = transactionData['from'] ?? 'Dental Office';
    final to = transactionData['to'] ?? 'Professional';
    final transactionId = transactionData['transactionId'] ?? 'N/A';
    final hourlyWage = transactionData['hourlyWage']?.toString() ?? '0'; // Corrected field name
    final date = transactionData['date'] ?? 'Unknown date';
    final professionalEmail = transactionData['professionalEmail'] ?? 'N/A';
    final officeEmail = transactionData['email'] ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.black,

      body: TransactionDetailWidget(
        from: from,
        to: to, // Added recipient name
        transactionID: transactionId,
        hourlyWage: "\$$hourlyWage/hour", // Formatted with $ and /hour
        date: date,
       // professionalEmail: professionalEmail,
        //officeEmail: officeEmail, // Added office email
      ),
    );
  }
}