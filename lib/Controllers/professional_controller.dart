import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Models/professional_user_model.dart';

class ProfessionalController extends GetxController {
  var professional = Professional().obs; // Observable object
  var skills = <String, bool>{
    "Trained and qualified to take x-rays": true,
    "Certified and trained for PPE and infection control protocols": true,
    "Trained and skilled to use ultrasonic scaler": true,
    "Trained and certified in CPR - up to date": false,
    "Trained and skilled to perform chairside teeth whitening": false,
    "Trained and skilled with certificate of completion to use soft-tissue laser for perio":
        true,
    "Trained and skilled with certificate of completion to offer restorative dental hygiene services":
        true,
    "Trained and skilled to perform chairside teeth whitening": false,
  }.obs;

  void updateSkill(String skill, bool value) {
    skills[skill] = value;
    update(); // Notify UI
  }

  void saveSkillsToProfessional() {
    professional.update((prof) {
      prof?.skillsAndQualifications = skills.entries
          .where((entry) => entry.value == true) // Get only selected skills
          .map((entry) => entry.key)
          .toList();
    });
  }

  void updateProfessional({
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
    String? email,
    String? password,
    String? role,
    String? uid,
    int? graduatingYear,
    String? licenseNumber,
    List<String>? skillsAndQualifications,
    String? workExperience,
    String? bio,
    String? imageUrl,
    String? emailPayment,
    Availability? availability,
  }) {
    professional.update((prof) {
      if (firstName != null) prof?.firstName = firstName;
      if (lastName != null) prof?.lastName = lastName;
      if (address != null) prof?.address = address;
      if (phoneNumber != null) prof?.phoneNumber = phoneNumber;
      if (email != null) prof?.email = email;
      if (password != null) prof?.password = password;
      if (role != null) prof?.role = role;
      if (graduatingYear != null) prof?.graduatingYear = graduatingYear;
      if (licenseNumber != null) prof?.licenseNumber = licenseNumber;
      if (skillsAndQualifications != null)
        prof?.skillsAndQualifications = skillsAndQualifications;
      if (workExperience != null) prof?.workExperience = workExperience;
      if (bio != null) prof?.bio = bio;
      if (imageUrl != null) prof?.imageUrl = imageUrl;
      if (emailPayment != null) prof?.emailPayment = emailPayment;
      if (uid != null) prof?.uid = uid;
    });
  }
}
