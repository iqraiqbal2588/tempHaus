// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:temp_haus_dental_clinic/Constants/colors.dart';
//
// class TermsAndConditionScreen extends StatefulWidget {
//   @override
//   State<TermsAndConditionScreen> createState() =>
//       _TermsAndConditionScreenState();
// }
//
// class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
//   String? termsText;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTerms();
//   }
//
//   Future<void> fetchTerms() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('admin')
//           .doc('termsCondition')
//           .get();
//
//       if (snapshot.exists) {
//         setState(() {
//           termsText = snapshot['terms'] ?? "No Terms Found.";
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           termsText = "Terms & Conditions not available.";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         termsText = "Failed to load terms.";
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colorss.appcolor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Terms & Condition",
//           style: TextStyle(color: Colors.white, fontSize: 18.sp),
//         ),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colorss.appcolor))
//           : Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SectionTitle(title: "Terms & Conditions"),
//                     SectionText(content: termsText ?? ""),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   // }
// }
//
// class SectionTitle extends StatelessWidget {
//   final String title;
//
//   const SectionTitle({Key? key, required this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.bold,
//         color: Colorss.appcolor,
//       ),
//     );
//   }
// }
//
// class SectionText extends StatelessWidget {
//   final String content;
//
//   const SectionText({Key? key, required this.content}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       content,
//       style: TextStyle(
//         fontSize: 14.sp,
//         color: Colors.white,
//         height: 1.5,
//       ),
//     );
//   }
// }
