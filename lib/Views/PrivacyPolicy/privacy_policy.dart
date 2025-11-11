import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String? policyText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('privacyPolicy')
          .get();

      if (snapshot.exists) {
        setState(() {
          policyText = snapshot['privacyPolicy'] ??
              "No Privacy Policy content available.";
          isLoading = false;
        });
      } else {
        setState(() {
          policyText = "Privacy Policy content not found.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        policyText = "Error loading Privacy Policy.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colorss.appcolor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colorss.appcolor))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: "Privacy Policy"),
                    SectionText(content: policyText ?? ""),
                  ],
                ),
              ),
            ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        color: Colorss.appcolor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String content;

  const SectionText({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }
}
