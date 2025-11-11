import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Controllers/office_controller.dart';
import 'package:temp_haus_dental_clinic/Controllers/professional_controller.dart';
import 'package:temp_haus_dental_clinic/Models/professional_user_model.dart';
import 'package:temp_haus_dental_clinic/Routes/approutes.dart';
import 'package:xor_encryption/xor_encryption.dart';

import '../Constants/colors.dart';
import '../Models/office_user_model.dart';

class AuthService {
  String secret =
      'GcyGHmMaeqRQQhfLlboKq296592F4wFFOY'; // Replace with your secret key
  String encrypted = '';
  String decrypted = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? deviceToken;

  bool isEmailValid(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  String encryptPassword(String password) {
    return XorCipher().encryptData(password, secret);
  }

  Future<void> signIn(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    if (formKey.currentState!.validate()) {
      if (!isEmailValid(emailController.text)) {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Invalid Email",
                style: TextStyle(color: Colors.black)),
            content: const Text("Please enter a valid email address.",
                style: TextStyle(color: Colorss.appcolor)),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          ),
        );
        return;
      }

      if (!isPasswordValid(passwordController.text)) {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Weak Password",
                style: TextStyle(color: Colors.black)),
            content: const Text("Password must be at least 6 characters.",
                style: TextStyle(color: Colorss.appcolor)),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          ),
        );
        return;
      }
      try {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Center(
              child: CircularProgressIndicator(
                color: Colorss.appcolor,
              ),
            ),
          ),
        );

        // Firebase Authentication
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Close loading
        Navigator.of(context).pop();

        // Success Snack
        Get.snackbar("Success", "Successfully Logged In",
            backgroundColor: Colorss.lightAppColor, colorText: Colors.black);

        // ✅ Check Firestore role after login
        final user = FirebaseAuth.instance.currentUser;
        final uid = user?.uid;
        String encryptedPassword = encryptPassword(passwordController.text);

        if (uid != null) {
          final officeDoc = await FirebaseFirestore.instance
              .collection('offices')
              .doc(uid)
              .get();

          final professionalDoc = await FirebaseFirestore.instance
              .collection('professionals')
              .doc(uid)
              .get();

          if (officeDoc.exists) {
            final data = officeDoc.data() as Map<String, dynamic>;
            final office = Office.fromJson(data);

            // Get your controller
            final OfficeController officeController =
                Get.put(OfficeController());

            // Update controller with fetched data
            officeController.updateOfficeDetails(
              email: office.email,
              password: office.password,
              officeName: office.officeName,
              address: office.address,
              phoneNumber: office.phoneNumber,
              officeEmail: office.officeEmail,
              officeType: office.officeType,
              image: office.image,
              cardDetailsList: office.cardDetailsList,
            );

            // Navigate to Office Bottom Navigation
            Get.offAllNamed(AppRoutes.bottomNav);
          } else if (professionalDoc.exists) {
            final data = professionalDoc.data() as Map<String, dynamic>;
            final professional = Professional.fromJson(data);

            // Get your ProfessionalController
            final ProfessionalController professionalController =
                Get.put(ProfessionalController());

            // Update controller with fetched data
            professionalController.updateProfessional(
              firstName: professional.firstName,
              lastName: professional.lastName,
              address: professional.address,
              phoneNumber: professional.phoneNumber,
              email: professional.email,
              password: professional.password,
              role: professional.role,
              graduatingYear: professional.graduatingYear,
              licenseNumber: professional.licenseNumber,
              skillsAndQualifications: professional.skillsAndQualifications,
              workExperience: professional.workExperience,
              bio: professional.bio,
              imageUrl: professional.imageUrl,
              emailPayment: professional.emailPayment,
            );
            Get.offAllNamed(AppRoutes.bottomNavProfessional);
          } else {
            Get.toNamed(AppRoutes.welcomescreen, parameters: {
              'email': emailController.text,
              'encryptedPassword': encryptedPassword
            });
          }
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        handleLoginError(e, context, emailController, passwordController);
      }
    } else {
      // Validation Error Dialog
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            "Validation Error",
            style: TextStyle(
              color: Colors.black,
              fontSize: 11.sp,
            ),
          ),
          content: Text(
            "Please fill in all the required fields.",
            style: TextStyle(
              color: Colorss.appcolor,
              fontSize: 11.sp,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text(
                "Ok",
                style: TextStyle(color: Colorss.appcolor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> handleLoginError(
    FirebaseAuthException e,
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    String messageToDisplay;
    switch (e.code) {
      case 'user-not-found':
        messageToDisplay = 'No user found for that email.';
        emailController.clear();
        passwordController.clear();
        break;

      case 'invalid-email':
        messageToDisplay = 'The email you entered is invalid.';
        emailController.clear();
        break;

      case 'wrong-password':
        messageToDisplay = 'Wrong password provided for that user.';
        passwordController.clear();
        break;

      default:
        messageToDisplay =
            'Login failed. Please check your credentials and try again.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Log In Failed",
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.sp,
          ),
        ),
        content: Text(
          messageToDisplay,
          style: TextStyle(
            color: Colorss.appcolor,
            fontSize: 11.sp,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              "Ok",
              style: TextStyle(
                color: Colorss.appcolor,
                fontSize: 11.sp,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> signUp(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    String name,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const CupertinoAlertDialog(
              title: Center(
                child: CircularProgressIndicator(
                  color: Colorss.appcolor,
                ),
              ),
            );
          },
        );

        // Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Encrypt Password
        String encryptedPassword = encryptPassword(passwordController.text);

        // Create User Model
        // UserModel user = UserModel(
        //   created: DateTime.now(),
        //   id: userCredential.user!.uid,
        //   password: encryptedPassword,
        //   email: emailController.text,
        // );

        // Save to Firestore
        // await userRef.doc(user.id).set(user.toMap());

        // Close loading dialog
        Navigator.of(context).pop();

        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text(
              "Sign Up Succeeded",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "Your Account Is Created, You Can Log In Now",
              style: TextStyle(color: Colorss.appcolor),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Get.offAllNamed(name, parameters: {
                    'email': emailController.text,
                    'encryptedPassword': encryptedPassword,
                  });
                },
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Close loading dialog before error
        handleSignError(e, context);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text(
            "Validation Error",
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            "Please fill in all the required fields.",
            style: TextStyle(color: Colorss.appcolor),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> handleSignError(
    FirebaseAuthException e,
    BuildContext context,
  ) async {
    String messageToDisplay;
    switch (e.code) {
      case "email-already-in-use":
        messageToDisplay = "This Email is already in use";
        break;

      case "invalid-email":
        messageToDisplay = "This Email you entered is Invalid";
        break;

      case "operation-not-allowed":
        messageToDisplay = "This operation is not allowed";
        break;

      case "weak-password":
        messageToDisplay = "The password you entered is too weak";
        break;

      default:
        messageToDisplay = "An Unknown Error Occurred";
        break;
    }
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
                title: const Text(
                  "Sign Up Failed",
                  style: TextStyle(color: Colors.black),
                ),
                content: Text(messageToDisplay,
                    style: const TextStyle(color: Colorss.appcolor)),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }
}
