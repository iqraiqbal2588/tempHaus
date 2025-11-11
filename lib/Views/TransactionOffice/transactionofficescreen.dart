import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/TransctionScreen/Widget/transction_card.dart';

class TransactionScreenOffice extends StatelessWidget {
  const TransactionScreenOffice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text(
          "Office Transactions",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .orderBy('createdAt', descending: true)
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
                  "No transaction history yet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final transactions = snapshot.data!.docs;

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final doc = transactions[index];
                final data = doc.data() as Map<String, dynamic>? ?? {};

                return TransactionCard(
                  image: "assets/IMAGE BG.png",
                  title: "Invoice ${data['professionalName'] ?? 'Professional'}",
                  description: "Date: ${data['date'] ?? 'N/A'}",
                  price: "\$${data['amount'] ?? '0'}",
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.transactionofficedetail,
                      arguments: data,
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
}