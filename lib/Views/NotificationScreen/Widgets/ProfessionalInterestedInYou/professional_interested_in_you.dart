import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/images.dart';

class ProfessionalInterestedInYou extends StatefulWidget {
  const ProfessionalInterestedInYou({super.key});

  @override
  State<ProfessionalInterestedInYou> createState() =>
      _ProfessionalInterestedInYouState();
}

class _ProfessionalInterestedInYouState extends State<ProfessionalInterestedInYou> {
  String? status;
  String? createdAt;
  late Map<String, dynamic> args;
  bool check = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    args = Get.arguments as Map<String, dynamic>;
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    try {
      final userId = args['userId'];
      final docId = args['docId'];
      final interestedUserId = args['interestedUserId'];

      final docSnap = await FirebaseFirestore.instance
          .collection('offices')
          .doc(userId)
          .collection('postingDetails')
          .doc(docId)
          .get();

      if (docSnap.exists) {
        final data = docSnap.data();
        final map = data?['statusMap'] ?? {};
        final result = data?['isAccepted'] ?? false;
        final createdAtTimestamp = data?['createdAt'];

        String formattedCreatedAt = 'N/A';
        if (createdAtTimestamp != null) {
          formattedCreatedAt = _formatFirestoreDate(createdAtTimestamp);
        }

        setState(() {
          status = map[interestedUserId] ?? '';
          check = result;
          createdAt = formattedCreatedAt;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching status: $e');
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'Failed to load data',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  String _formatFirestoreDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    try {
      if (timestamp is Timestamp) {
        return DateFormat('MMM d, yyyy hh:mm a').format(timestamp.toDate());
      } else if (timestamp is String) {
        return DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(timestamp));
      }
      return 'N/A';
    } catch (e) {
      print('Error formatting date: $e');
      return 'N/A';
    }
  }

  String _formatDay(String dayString) {
    if (dayString.isEmpty) return 'N/A';

    try {
      final parsedDay = DateTime.tryParse(dayString);
      return parsedDay != null
          ? DateFormat('EEE, MMM d, yyyy').format(parsedDay)
          : dayString;
    } catch (e) {
      print('Error parsing day: $e');
      return dayString;
    }
  }

  String _formatTime(String timeString) {
    if (timeString.isEmpty) return 'N/A';

    try {
      final parsedTime = DateTime.tryParse(timeString);
      return parsedTime != null
          ? DateFormat('hh:mm a').format(parsedTime)
          : timeString;
    } catch (e) {
      print('Error parsing time: $e');
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String jobTitle = args['jobTitle'] ?? 'No Title';
    final String workplace = args['workplace'] ?? 'No Workplace';
    final String location = args['location'] ?? 'No Location';
    final double payRate = args['payRate'] ?? 0.0;
    final String imageUrl = args['imageUrl'] ?? '';
    final String details = args['detail'] ?? 'No details provided';
    final String userId = args['userId'] ?? '';
    final String docId = args['docId'] ?? '';
    final String day = args['day'] ?? '';
    final String startTime = args['startTime'] ?? '';
    final String endTime = args['endTime'] ?? '';
    final String interestedUserId = args['interestedUserId'] ?? '';
    final String name = args['name'] ?? 'No Name';

    final formattedDay = _formatDay(day);
    final formattedStart = _formatTime(startTime);
    final formattedEnd = _formatTime(endTime);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(imageUrl),
              Container(
                decoration: BoxDecoration(
                  color: Colorss.lightAppColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Column(
                  children: [
                    _buildDetailSection(
                      jobTitle,
                      workplace,
                      location,
                      payRate,
                      formattedDay,
                      formattedStart,
                      formattedEnd,
                      createdAt ?? 'N/A',
                      details,
                    ),
                    SizedBox(height: 20.h),
                    _buildInterestedText(name, createdAt ?? 'N/A'),
                    SizedBox(height: 20.h),
                    _buildActionButtons(
                      userId,
                      docId,
                      interestedUserId,
                      name,
                      payRate,
                      createdAt ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return Center(
      child: Container(
        height: 280.h,
        width: 320.w,
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: url.isNotEmpty
                ? NetworkImage(url)
                : AssetImage(Images.onboarding1Img) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
      String jobTitle,
      String workplace,
      String location,
      double rate,
      String day,
      String start,
      String end,
      String createdAt,
      String detail,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colorss.silkColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jobTitle,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),


          SizedBox(height: 10.h),
          _buildInfoRow(
            Icons.location_on,
            location,
            'Rate: \$${rate.toStringAsFixed(2)} / hr',
          ),
          SizedBox(height: 10.h),
          _buildDateRow(createdAt,),
          SizedBox(height: 16.h),
          _buildSectionHeader('Job Description'),
          SizedBox(height: 8.h),
          Text(
            detail,
            style: TextStyle(fontSize: 13.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String trailing) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16.sp),
        SizedBox(width: 6.w),
        Expanded(child: Text(title, style: TextStyle(fontSize: 14.sp))),
        Text(
          trailing,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildDateRow(String createdAt, ) {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: Colors.grey, size: 16.sp),
        SizedBox(width: 6.w),
        Expanded(child: Text("Date: $createdAt", style: TextStyle(fontSize: 14.sp))),

      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInterestedText(String name, String createdAt) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colorss.appcolor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colorss.appcolor),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "This professional ",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                        ),
                        const TextSpan(text: " is interested in you."),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 6.w),
                Text(
                  'Interest shown on: $createdAt',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      String userId,
      String docId,
      String interestedUserId,
      String name,
      double payRate,
      String createdAt,
      ) {
    bool isDisabled = check;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleButton(
            label: "Accept",
            color: Colors.green,
            isDisabled: isDisabled,
            onPressed: () async {
              await _updateStatus(userId, docId, interestedUserId, "accepted");

              final now = DateTime.now();
              final formattedDate = DateFormat('EEE, MMM d, yyyy').format(now);
              final formattedTime = DateFormat('hh:mm a').format(now);

              final transactionId = FirebaseFirestore.instance
                  .collection('transactions')
                  .doc()
                  .id;

              final officeDoc = await FirebaseFirestore.instance
                  .collection('offices')
                  .doc(userId)
                  .get();
              final officeData = officeDoc.data() ?? {};
              final officeEmail = officeData['email'] ?? '';
              final officeName = officeData['name'] ?? '';

              await _saveTransaction(
                transactionId: transactionId,
                professionalName: name,
                professionalId: interestedUserId,
                amount: payRate,
                date: formattedDate,
                time: formattedTime,
                officeName: officeName,
                officeEmail: officeEmail,
              );

              setState(() => status = "accepted");

              _showInvoiceDialog(
                professionalName: name,
                professionalId: interestedUserId,
                hourlyRate: payRate,
                date: formattedDate,
                time: formattedTime,
                officeName: officeName,
                officeEmail: officeEmail,
                createdAt: createdAt,
              );

              await _fetchStatus();
            },
          ),
          _buildSingleButton(
            label: "Reject",
            color: Colors.red,
            isDisabled: isDisabled,
            onPressed: () async {
              await _updateStatus(userId, docId, interestedUserId, "rejected");
              setState(() => status = "rejected");
              Get.snackbar(
                "Rejected",
                "You rejected the request.",
                backgroundColor: Colorss.lightAppColor,
                colorText: Colors.black,
              );
              await _fetchStatus();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSingleButton({
    required String label,
    required Color color,
    required bool isDisabled,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? color.withOpacity(0.4) : color,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _updateStatus(
      String userId,
      String docId,
      String interestedUserId,
      String status,
      ) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('offices')
          .doc(userId)
          .collection('postingDetails')
          .doc(docId);

      final Map<String, dynamic> updates = {
        'statusMap.$interestedUserId': status,
      };

      if (status == 'accepted') {
        updates['isAccepted'] = true;
      } else if (status == 'rejected') {
        updates['isAccepted'] = false;
      }

      await docRef.update(updates);
    } catch (e) {
      print('Error updating status: $e');
      Get.snackbar(
        'Error',
        'Failed to update status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveTransaction({
    required String transactionId,
    required String professionalName,
    required String professionalId,
    required double amount,
    required String date,
    required String time,
    required String officeName,
    required String officeEmail,
  }) async {
    try {
      final transactionData = {
        'transactionId': transactionId,
        'professionalName': professionalName,
        'professionalId': professionalId,
        'amount': amount.toStringAsFixed(2),
        'date': date,
        'time': time,
        'officeName': officeName,
        'officeEmail': officeEmail,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .set(transactionData);
    } catch (e) {
      print('Error saving transaction: $e');
      Get.snackbar(
        'Error',
        'Failed to save transaction',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showInvoiceDialog({
    required String professionalName,
    required String professionalId,
    required double hourlyRate,
    required String date,
    required String time,
    required String officeName,
    required String officeEmail,
    required String createdAt,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInvoiceRow("Office Email:", officeEmail),
              _buildInvoiceRow("Professional Name:", professionalName),
              _buildInvoiceRow("Professional ID:", professionalId),
              _buildInvoiceRow("Hourly Rate:", "\$${hourlyRate.toStringAsFixed(2)}"),
              _buildInvoiceRow("Date:", createdAt),
              _buildInvoiceRow("Time:", time),
              _buildInvoiceRow("Posted At:", createdAt),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.back();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}