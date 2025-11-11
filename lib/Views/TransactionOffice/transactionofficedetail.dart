import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TransactionDetailScreenOffice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionData = Get.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Transaction Details",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildDetailRow("Office Name:", transactionData['officeName'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Office Email:", transactionData['officeEmail'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Professional:", transactionData['professionalName'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Professional ID:", transactionData['professionalId'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Amount:", "\$${transactionData['amount'] ?? '0'}"),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Date:", transactionData['date'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Time:", transactionData['time'] ?? 'N/A'),
            Divider(color: Colors.grey[700], height: 20.h),
            _buildDetailRow("Transaction ID:", transactionData['transactionId'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}