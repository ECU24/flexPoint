import 'package:finalyearproject_flutter_application_1/authentication/authentication_repository.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_model.dart';

class SignUpFields extends GetxController {
  static SignUpFields get instance => Get.find();

  
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  
  void registerUser(String email, String password) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }

  void loginUser(String email, String password) {
    AuthenticationRepository.instance
        .loginUserWithEmailAndPassword(email, password);
  }

  

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
    registerUser(user.email, user.password);
  }
}
