import 'package:finalyearproject_flutter_application_1/authentication/signup_failure.dart';
import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/mainmenu_screen.dart';
//import 'package:finalyearproject_flutter_application_1/screens/home_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/plansessions_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/pointsQuestion_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const StartScreen())
        : Get.offAll(() =>
            const StartScreen()); //if you login it goes to this screen i think
  }

  // Future<void> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     //add new screen
  //     firebaseUser.value != null
  //         ? Get.offAll(() => const WelcomeScreen())
  //         : Get.to(() => WelcomeScreen());
  //   } on FirebaseAuthException catch (e) {
  //     final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
  //     print('FIREBASE AUTH EXCEPTION - ${ex.message}');
  //     throw ex;
  //   } catch (_) {}
  //   const ex = SignUpWithEmailAndPasswordFailure();
  //   print('EXCEPTION - ${ex.message}');
  //   throw ex;
  // }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (firebaseUser.value != null) {
        Get.offAll(() => const PlanSessionsScreen());
      } else {
        Get.snackbar("Error", "User registration failed.");
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar("Sign Up Error", ex.message);
      throw ex;
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
      throw SignUpWithEmailAndPasswordFailure();
    }
  }

  // Future<void> loginUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //   } on FirebaseAuthException {
  //   } catch (_) {}
  // }

  //Login User with Email and Password
  // Future<void> loginUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);

  //     //Redirect to home screen after login
  //     Get.offAll(() => const WelcomeScreen());
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar("Login Error", e.message ?? "Failed to log in.");
  //   } catch (e) {
  //     Get.snackbar("Error", "An unexpected error occurred.");
  //   }
  // }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      email = email.trim();
      password = password.trim();

      if (!GetUtils.isEmail(email)) {
        Get.snackbar("Invalid Email", "Please enter a valid email address.");
        return;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.offAll(() => const PointsQuestion());
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to log in.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format.";
      }

      Get.snackbar("Login Error", errorMessage);
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const StartScreen());

    UserRepository.instance.setFirstName('');
    UserRepository.instance.setEmail('');

    final signUpController = Get.find<SignUpFields>();
    signUpController.email.clear();
    signUpController.password.clear();
  }
}
