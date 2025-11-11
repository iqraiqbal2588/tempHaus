import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/images.dart';

class OfficeInviteYou extends StatefulWidget {
  const OfficeInviteYou({super.key});

  @override
  State<OfficeInviteYou> createState() => _OfficeInviteYouState();
}

class _OfficeInviteYouState extends State<OfficeInviteYou> {
  String? status;
  bool check = false;
  late Map<String, dynamic> args;
  String professionalFirstName = '';
  String professionalLastName = '';
  String officeName = '';
  String professionalId = '';
  String officeId = '';
  String docId = '';
  String professionalHourlyWage = '0'; // Initialize with default value

  @override
  void initState() {
    super.initState();
    args = Get.arguments as Map<String, dynamic>;
    professionalId = args['userId'] ?? '';
    officeId = args['inviteOfficeUid'] ?? '';
    docId = args['docId'] ?? '';
    _fetchStatus();
    _fetchProfessionalAndOfficeData();
    _fetchProfessionalHourlyWage(); // Add this to fetch hourly wage
  }

  Future<void> _fetchProfessionalHourlyWage() async {
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(professionalId)
          .collection('availability')
          .doc(docId)
          .get();

      if (docSnap.exists) {
        setState(() {
          professionalHourlyWage = docSnap.data()?['hourlyWage']?.toString() ?? '0';
        });
      }
    } catch (e) {
      print('Error fetching hourly wage: $e');
    }
  }

  Future<void> _fetchProfessionalAndOfficeData() async {
    if (professionalId.isNotEmpty) {
      final professionalDoc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(professionalId)
          .get();

      if (professionalDoc.exists) {
        setState(() {
          professionalFirstName = professionalDoc.data()?['firstName'] ?? '';
          professionalLastName = professionalDoc.data()?['lastName'] ?? '';
        });
      }
    }

    if (officeId.isNotEmpty) {
      final officeDoc = await FirebaseFirestore.instance
          .collection('offices')
          .doc(officeId)
          .get();

      if (officeDoc.exists) {
        setState(() {
          officeName = officeDoc.data()?['officeName'] ?? officeDoc.data()?['name'] ?? '';
        });
      }
    }
  }

  Future<void> _fetchStatus() async {
    final docSnap = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(professionalId)
        .collection('availability')
        .doc(docId)
        .get();

    if (docSnap.exists) {
      final data = docSnap.data();
      final map = data?['statusMap'] ?? {};
      final result = data?['isAccepted'] ?? false;
      setState(() {
        status = map[officeId] ?? '';
        check = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String jobTitle = args['jobTitle'] ?? '';
    final String workplace = args['workplace'] ?? '';
    final String location = args['location'] ?? '';
    final String payRate = args['payRate'] ?? '';
    final String imageUrl = args['imageUrl'] ?? '';
    final String about = args['about'] ?? '';
    final String day = args['day'] ?? '';
    final String startTime = args['startTime'] ?? '';
    final String endTime = args['endTime'] ?? '';
    final String name = args['name'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(imageUrl),
              Container(
                height: 500.h,
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
                      day,
                      startTime,
                      endTime,
                      about,
                    ),
                    SizedBox(height: 40.h),
                    _buildInterestedText(name),
                    SizedBox(height: 40.h),
                    _buildActionButtons(),
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
       child: SvgPicture.asset('assets/post_job.svg'),
      ),
    );
  }

  Widget _buildDetailSection(
      String jobTitle,
      String workplace,
      String location,
      String rate,
      String day,
      String start,
      String end,
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
          Text(jobTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(workplace, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          SizedBox(height: 10.h),
          _buildInfoRow(Icons.location_on, location, 'Rate: \$${rate} / Day'),
          SizedBox(height: 10.h),
          _buildInfoRow(Icons.attach_money, 'Hourly Wage:', '\$$professionalHourlyWage'),
          SizedBox(height: 10.h),
          _buildDateRow(day, start, end),
          SizedBox(height: 16.h),
          _buildSectionHeader('About you'),
          SizedBox(height: 8.h),
          Text(detail, style: TextStyle(fontSize: 13.sp, color: Colors.black)),
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
        Text(trailing, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
      ],
    );
  }

  Widget _buildDateRow(String day, String start, String end) {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: Colors.grey, size: 16.sp),
        SizedBox(width: 6.w),
        Expanded(child: Text("Date: $day", style: TextStyle(fontSize: 14.sp))),
        Text("$start - $end", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
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
        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildInterestedText(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colorss.appcolor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.favorite, color: Colorss.appcolor),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: "This Office ",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: "$name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                    TextSpan(text: " invited you."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
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
              final availabilityDoc = await FirebaseFirestore.instance
                  .collection('professionals')
                  .doc(professionalId)
                  .collection('availability')
                  .doc(docId)
                  .get();

              final availabilityData = availabilityDoc.data() ?? {};
              final hourlyWage = availabilityData['hourlyWage'] ?? '0';

              final professionalDoc = await FirebaseFirestore.instance
                  .collection('professionals')
                  .doc(professionalId)
                  .get();

              final professionalData = professionalDoc.data() ?? {};
              final professionalEmail = professionalData['email'] ?? '';
              final professionalName = "$professionalFirstName $professionalLastName";

              final officeDoc = await FirebaseFirestore.instance
                  .collection('offices')
                  .doc(officeId)
                  .get();

              final officeData = officeDoc.data() ?? {};
              final officeEmail = officeData['officeEmail'] ?? officeData['email'] ?? '';

              await _updateStatus("accepted");

              final now = DateTime.now();
              final formattedDate = "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

              final transactionId = FirebaseFirestore.instance.collection('transactions').doc().id;

              final transactionData = {
                "from": officeName,
                "to": professionalName,
                "email": officeEmail,
                "professionalEmail": professionalEmail,
                "transactionId": transactionId,
                "hourlyWage": hourlyWage.toString(),
                "date": formattedDate,
                "officeId": officeId,
                "professionalId": professionalId,
                "professionalName": professionalName,
              };

              await FirebaseFirestore.instance.collection('transactions').doc(transactionId).set(transactionData);

              setState(() => status = "accepted");

              _showInvoiceDialog(amount: hourlyWage.toString(), date: formattedDate);

              await _fetchStatus();
            },
          ),
          _buildSingleButton(
            label: "Reject",
            color: Colors.red,
            isDisabled: isDisabled,
            onPressed: () async {
              await _updateStatus("rejected");
              setState(() => status = "rejected");
              Get.snackbar("Rejected", "You rejected the request.", backgroundColor: Colorss.lightAppColor, colorText: Colors.black);
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
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Future<void> _updateStatus(String status) async {
    final docRef = FirebaseFirestore.instance
        .collection('professionals')
        .doc(professionalId)
        .collection('availability')
        .doc(docId);

    final Map<String, dynamic> updates = {
      'statusMap.$officeId': status,
    };

    updates['isAccepted'] = (status == 'accepted');

    await docRef.update(updates);
  }

  void _showInvoiceDialog({
    required String amount,
    required String date,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Invoice"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInvoiceRow("From:", officeName),
                _buildInvoiceRow("Office ID:", officeId),
                _buildInvoiceRow("Professional ID:", professionalId),
                _buildInvoiceRow("Hourly Wage:", "\$$amount"),
                _buildInvoiceRow("Date:", date),
              ],
            ),
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
          Text("$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}