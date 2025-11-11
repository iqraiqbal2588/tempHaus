import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String? aboutText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAboutText();
  }

  Future<void> fetchAboutText() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc('aboutUs')
          .get();

      if (snapshot.exists) {
        setState(() {
          aboutText = snapshot['aboutUs'] ?? "No About Us content available.";
          isLoading = false;
        });
      } else {
        setState(() {
          aboutText = "About Us content not found.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        aboutText = "Error fetching About Us content.";
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
          "About us",
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
                    SectionText(content: aboutText ?? ""),
                  ],
                ),
              ),
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
