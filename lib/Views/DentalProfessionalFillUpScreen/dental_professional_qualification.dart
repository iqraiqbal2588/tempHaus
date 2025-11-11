import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Constants/colors.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:temp_haus_dental_clinic/Widgets/forward_circle_widget.dart';

class DentalProfessionalSkillsScreen extends StatefulWidget {
  @override
  State<DentalProfessionalSkillsScreen> createState() =>
      _DentalProfessionalSkillsScreenState();
}

class _DentalProfessionalSkillsScreenState
    extends State<DentalProfessionalSkillsScreen> {
  final ProfessionalController controller = Get.find<ProfessionalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Dental Professional",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 300.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFC7A777),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(5.r)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 10.0.w),
              child: Text(
                "Enter your skills and qualifications\nbelow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Skills List with Checkboxes (Uses Obx)
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.skills.length,
                  itemBuilder: (context, index) {
                    String skill = controller.skills.keys.elementAt(index);
                    return Row(
                      children: [
                        Checkbox(
                          value: controller.skills[skill],
                          activeColor: Colorss.appcolor,
                          checkColor: Colors.black,
                          onChanged: (bool? value) {
                            controller.updateSkill(skill, value!);
                          },
                        ),
                        Expanded(
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CustomCircleAvatar(
                  onPressed: () {
                    controller.saveSkillsToProfessional();
                    Get.toNamed(AppRoutes.professionalsExperience);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
