import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/Widget/next_button.dart';

class HourlyRateScreen extends StatefulWidget {
  @override
  _HourlyRateScreenState createState() => _HourlyRateScreenState();
}

class _HourlyRateScreenState extends State<HourlyRateScreen> {
  final TextEditingController rateController = TextEditingController();
  final OfficeController officeController = Get.find<OfficeController>();

  @override
  void dispose() {
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Post Job",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Row(
              children: [
                Container(
                  width: 230.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFC7A777),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(0)),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "What hourly rate would you like to offer?",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.attach_money, color: Colors.black),
                  hintText: "Enter dollar Amount",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
                label: Text("Previous",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              ),
              Center(
                child: NextContainer(
                  buttonText: 'Next',
                  onPressed: () {
                    final priceText = rateController.text.trim();
                    if (priceText.isNotEmpty) {
                      double price = double.tryParse(priceText) ?? 0.0;

                      // Check if the price is a valid positive number
                      if (price > 0) {
                        officeController.updatePostingDetails(amount: price);
                        Get.toNamed(AppRoutes.postJobDetail);
                      } else {
                        // Show an error if the rate is not a valid positive number
                        Get.snackbar(
                          "Invalid Amount",
                          "Please enter a valid positive hourly rate",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                          "Input Required", "Please enter a valid hourly rate",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
