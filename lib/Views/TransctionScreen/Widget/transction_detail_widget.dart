import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart'; // Assuming you have this

class TransactionDetailWidget extends StatelessWidget {
  final String from;
  final String to;
  final String transactionID;
  final String hourlyWage;
  final String date;

  const TransactionDetailWidget({
    super.key,
    required this.from,
    required this.to,
    required this.transactionID,
    required this.hourlyWage,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colorss.appcolor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Transaction Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.business, "From:", from),
                _buildDivider(),
                _buildDetailRow(Icons.person, "To:", to),
                _buildDivider(),
                _buildDetailRow(Icons.receipt, "Transaction ID:", transactionID),
                _buildDivider(),
                _buildDetailRow(Icons.attach_money, "Hourly Wage:", hourlyWage),
                _buildDivider(),
                _buildDetailRow(Icons.calendar_today, "Date:", _formatDate(date)),
                SizedBox(height: 20.h),
                _buildReceiptFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colorss.appcolor, size: 24.sp), // Using app color for icons
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      height: 1.h,
      thickness: 1,
    );
  }

  Widget _buildReceiptFooter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colorss.appcolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colorss.appcolor, size: 24.sp),
          SizedBox(width: 10.w),
          Text(
            "Verified Transaction",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.contains('-') && dateString.contains(':')) {
        final parts = dateString.split(' ');
        if (parts.length == 2) {
          final dateParts = parts[0].split('-');
          final timeParts = parts[1].split(':');

          if (dateParts.length == 3 && timeParts.length == 2) {
            final day = dateParts[0];
            final month = _getMonthName(int.parse(dateParts[1]));
            final year = dateParts[2];
            final hour = int.parse(timeParts[0]);
            final minute = timeParts[1].padLeft(2, '0');

            final period = hour >= 12 ? 'PM' : 'AM';
            final displayHour = hour > 12 ? hour - 12 : hour;

            return '$day $month $year, ${displayHour.toString().padLeft(2, '0')}:$minute $period';
          }
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}