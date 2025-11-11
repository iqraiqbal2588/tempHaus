import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:temp_haus_dental_clinic/Views/AboutUs/about_us.dart';
import 'package:temp_haus_dental_clinic/Views/AddSchedule/add_schedule_office.dart';
import 'package:temp_haus_dental_clinic/Views/AddSchedule/add_schedule_professional.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/Widgets/welcom_office_screen.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/forget_password.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/login_screen.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/sign_up.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/verification_password_screen.dart';
import 'package:temp_haus_dental_clinic/Views/AuthScreens/verification_screen.dart';
import 'package:temp_haus_dental_clinic/Views/BottomNavBar/Office_bottom_nav_bar.dart';
import 'package:temp_haus_dental_clinic/Views/BottomNavBar/professional_bottom_nav_bar.dart';
import 'package:temp_haus_dental_clinic/Views/DashboardProfessional/professional_doctor_detail.dart';
import 'package:temp_haus_dental_clinic/Views/DashboardProfessional/success_screen.dart';
import 'package:temp_haus_dental_clinic/Views/DentalOfiiceDetailsFillUpScreen/detail_screen1.dart';
import 'package:temp_haus_dental_clinic/Views/DentalOfiiceDetailsFillUpScreen/detail_screen2.dart';
import 'package:temp_haus_dental_clinic/Views/DentalOfiiceDetailsFillUpScreen/detail_screen3.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/available_professional_days.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/completed_screen.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/dental_professional_qualification.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/dental_professional_upload_pick.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/dental_professional_work_experience.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/endtime_professionals.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/professional_hourly_wage.dart';
import 'package:temp_haus_dental_clinic/Views/DentalProfessionalFillUpScreen/start_time_professionals.dart';
import 'package:temp_haus_dental_clinic/Views/DoctorProfile/doctor_profile.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/available_days.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/end_time_picker_screen.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/hourly_rate_screen.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/job_information_basic.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/job_information_details.dart';
import 'package:temp_haus_dental_clinic/Views/JobPosts/post_job_1.dart';
import 'package:temp_haus_dental_clinic/Views/MyPostd/office_posts_screen.dart';
import 'package:temp_haus_dental_clinic/Views/MyPostd/professional_post_screen.dart';
import 'package:temp_haus_dental_clinic/Views/OfficeHomePage/office_home_page.dart';
import 'package:temp_haus_dental_clinic/Views/OnBoardingScreen/on_boarding_screen.dart';
import 'package:temp_haus_dental_clinic/Views/PrivacyPolicy/privacy_policy.dart';
import 'package:temp_haus_dental_clinic/Views/ProfileScreen/edit_office_screen.dart';
import 'package:temp_haus_dental_clinic/Views/ProfileScreen/edit_profile_professional_screen.dart';
import 'package:temp_haus_dental_clinic/Views/ProfileScreen/professional_profile_screen.dart';
import 'package:temp_haus_dental_clinic/Views/RoleSelectionScreen/role_selection.dart';
import 'package:temp_haus_dental_clinic/Views/SplashScreen/splash_screen.dart';
import 'package:temp_haus_dental_clinic/Views/TermsAndCondition/terms_&_condition.dart';
import 'package:temp_haus_dental_clinic/Views/TransactionOffice/transactionofficedetail.dart';
import 'package:temp_haus_dental_clinic/Views/TransactionOffice/transactionofficescreen.dart';
import 'package:temp_haus_dental_clinic/Views/TransctionScreen/transction_detail.dart';
import 'package:temp_haus_dental_clinic/Views/TransctionScreen/transction_screen.dart';
import 'package:temp_haus_dental_clinic/Views/WelcomeScreens/welcome_screen_Dental_clinic.dart';

import '../Views/AuthScreens/welcomescreen.dart';
import '../Views/DentalProfessionalFillUpScreen/dental_professional_detail1.dart';
import '../Views/DentalProfessionalFillUpScreen/dental_professional_detail2.dart';
import '../Views/JobPosts/start_time_picker_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/dental/onboarding';
  static const String roleSelection = '/dental/roleSelection';
  static const String login = '/dental/login';
  static const String signup = '/dental/signup';
  static const String forgetPassword = '/dental/forgetScreen';
  static const String verification = '/dental/verfication';
  static const String newPassword = '/dental/newPassword';
  static const String welcomeDentalScreen = '/dental/welcome/dental/screen';
  static const String addNewCreditCard = '/dental/addNewCreditCard';
  static const String tempDetail1 = '/dental/temp/detail1';
  static const String tempDetail2 = '/dental/temp/detail2';
  static const String tempDetail3 = '/dental/temp/detail3';
  static const String welcomescreen = '/dental/temp/welcomescreen';
  static const String homePage = '/dental/temp/homePage';
  static const String welcomeOffices = '/dental/temp/welcomeOffice';
  static const String postJob1 = '/dental/temp/postJob1';
  static const String availableTime = '/dental/temp/availableTime';
  static const String timePicker = '/dental/temp/timePicker';
  static const String endTimePicker = '/dental/temp/endtimePicker';
  static const String hourlyRate = '/dental/temp/hourlyRate';
  static const String postJobDetail = '/dental/temp/postjobdetail';
  static const String postJobDetailBasic = '/dental/temp/postjobdetailbasic';
  static const String payementScreen = '/dental/temp/payementScreen';
  static const String addCreditCard = '/dental/temp/addCard';
  static const String bottomNav = '/dental/temp/bottomNav';
  static const String bottomNavProfessional =
      '/dental/temp/ProfessionalbottomNav';
  static const String professionalsDetail1 =
      '/dental/temp/professionalsDetail1';
  static const String professionalsDetail2 =
      '/dental/temp/professionalsDetail2';
  static const String professionalSkills = '/dental/temp/professionalsSkills';
  static const String professionalsExperience =
      '/dental/temp/professionalsExperience';
  static const String professionalsUploads = '/dental/temp/professionalsUpload';
  static const String professionalsCompleted =
      '/dental/temp/professionalsCompleted';
  static const String professionalsAvailable =
      '/dental/temp/professionalsAvailable';
  static const String professionalsStartTime =
      '/dental/temp/professionalsStartTime';
  static const String professionalsEndTime =
      '/dental/temp/professionalsEndTime';
  static const String professionalsWagesScreen =
      '/dental/temp/professionalsWages';
  static const String profileOfficePage = '/dental/temp/officeProfilePage';
  static const String transactionDetail = '/dental/temp/transactionDetail';
  static const String transactionScreen = '/dental/temp/transactionScreen';
  static const String transactionofficescreen = '/transactionofficescreen';
  static const String transactionofficedetail = '/transactionofficedetail';
  static const String paymentOptionsOffice = '/dental/temp/paymentOptions';
  static const String termsCondition = '/dental/temp/termsCondition';
  static const String aboutUs = '/dental/temp/aboutUs';
  static const String privacyPolicy = '/dental/temp/privacyPolicy';
  static const String doctorProfile = '/dental/temp/doctorProfile';
  static const String doctorProfileDetail = '/dental/temp/doctorProfileDetail';
  static const String successScreenProfessional =
      '/dental/temp/successScreenProfessional';
  static const String addSchedule = '/dental/temp/addSchedule';
  static const String addScheduleOffice = '/dental/temp/addScheduleOffice';
  static const String editProfessionalProfile = '/dental/temp/editprofile';
  static const String editOfficeProfile = '/dental/temp/editprofileoffice';
  static const String officePostScreen = '/dental/temp/officePostScreen';
  static const String professionalPostScreen =
      '/dental/temp/professionalPostScreen';
  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: roleSelection, page: () => RoleSelection()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: forgetPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verification, page: () => VerifyAccountScreen()),
    GetPage(name: newPassword, page: () => CreateNewPasswordScreen()),
  GetPage(
  name: '/welcomeDentalScreen',
  page: () {
  // Get the current user from Firebase Auth
  final user = FirebaseAuth.instance.currentUser;
  final userName = user?.displayName ?? 'Dental Office'; // Fallback name

  return WelcomeDentalOfficeScreen(
  userName: userName,
  );
  },
  // Optional: Add transition if needed
  transition: Transition.rightToLeft,
  transitionDuration: Duration(milliseconds: 300),
  ),
    //GetPage(name: tempPosting, page: () => TempingScreen()),
    GetPage(name: tempDetail1, page: () => DentalOfficeFormScreen()),
    GetPage(name: tempDetail2, page: () => DentalOfficeScreen2()),
    GetPage(name: tempDetail3, page: () => DentalOfficeScreen3()),
    GetPage(name: homePage, page: () => OfficeHomeScreen()),
    GetPage(name: welcomescreen, page: () => WelcomeScreen()),
    GetPage(name: welcomeOffices, page: () => WelcomeScreenOffice()),
    GetPage(name: postJob1, page: () => PostJobScreen()),
    GetPage(name: availableTime, page: () => AvailableDaysScreen()),
    GetPage(name: timePicker, page: () => StartTimePickerScreen()),
    GetPage(name: endTimePicker, page: () => EndTimePickerScreen()),
    GetPage(name: hourlyRate, page: () => HourlyRateScreen()),
    GetPage(name: postJobDetail, page: () => PostJobDetailScreen()),
    GetPage(name: postJobDetailBasic, page: () => PostJobDetailBasicScreen()),
    GetPage(
        name: professionalsDetail1,
        page: () => DentalProfessionalForm1Screen()),
    GetPage(
        name: professionalsDetail2,
        page: () => DentalProfessionalForm2Screen()),
    GetPage(
        name: professionalSkills, page: () => DentalProfessionalSkillsScreen()),
    GetPage(
        name: professionalsExperience, page: () => professional_experience()),
    GetPage(name: professionalsUploads, page: () => DentalProfessionalUpload()),
    GetPage(
        name: professionalsCompleted,
        page: () => CompletedProfessionalScreen()),
    GetPage(
        name: professionalsAvailable,
        page: () => AvailableDaysProfessionalScreen()),
    GetPage(
        name: professionalsStartTime,
        page: () => StartTimePickerProfessionalsScreen()),
    GetPage(
        name: professionalsEndTime,
        page: () => EndTimePickerProfessionalsScreen()),
    GetPage(name: professionalsWagesScreen, page: () => ProfessionalWages()),
    GetPage(name: bottomNav, page: () => MainPage()),
    GetPage(name: bottomNavProfessional, page: () => MainPageProfessional()),
    GetPage(name: profileOfficePage, page: () => ProfessionalProfileScreen()),
    GetPage(name: transactionScreen, page: () => TransactionScreen()),
    GetPage(name: transactionDetail, page: () => TransactionDetailScreen()),
    GetPage(name: transactionofficescreen, page: () => TransactionScreenOffice()),
    GetPage(name: transactionofficedetail, page: () => TransactionDetailScreenOffice()),
    GetPage(name: aboutUs, page: () => AboutUsScreen()),

    GetPage(name: privacyPolicy, page: () => PrivacyPolicyScreen()),
    GetPage(name: doctorProfile, page: () => DoctorProfileScreen()),
    GetPage(name: doctorProfileDetail, page: () => ProfessionalDentalsDetail()),
    GetPage(name: successScreenProfessional, page: () => SuccessScreen()),
    GetPage(name: addSchedule, page: () => AddScheduleScreen()),
    GetPage(
        name: editProfessionalProfile,
        page: () => EditProfileProfessionalScreen()),
    GetPage(name: addScheduleOffice, page: () => OfficeAddScheduleScreen()),
    GetPage(name: editOfficeProfile, page: () => EditProfileOfficeScreen()),
    GetPage(name: officePostScreen, page: () => OfficePostsScreen()),
    GetPage(
        name: professionalPostScreen, page: () => ProfessionalPostsScreen()),
  ];
}
