import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_model.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/points/points.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalyearproject_flutter_application_1/points/points_repository.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpFields());
    final _formKey = GlobalKey<FormState>();
    final controllerPR = Get.put(PointsRepository());

    void setZeroPoints() async {
      final zeroPoints = Points(points: 0);
      String userEmail = controller.email.text.trim();

      String? userID =
          await UserRepository.instance.getUserDocumentId(userEmail);

      controllerPR.setPoints(zeroPoints, userID);
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 32, 32, 41),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Color.fromARGB(255, 32, 32, 41),
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Text('Sign Up Here',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text(
                          'Fill in the details below and let the journey begin',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                        controller: controller.firstName,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person_outline_outlined,
                                            ),
                                            labelText: 'First Name',
                                            hintText: 'First Name',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            border: OutlineInputBorder())),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: controller.lastName,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person_outline_outlined,
                                              // color: Color.fromARGB(255, 75, 39, 116)
                                            ),
                                            labelText: 'Last Name',
                                            hintText: 'Last Name',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            border: OutlineInputBorder())),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: controller.email,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                              // color: Color.fromARGB(255, 75, 39, 116)
                                            ),
                                            labelText: 'E-Mail',
                                            hintText: 'E-Mail',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            border: OutlineInputBorder())),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: controller.password,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.fingerprint,
                                              // color: Color.fromARGB(255, 75, 39, 116)
                                            ),
                                            labelText: 'Password',
                                            hintText: 'Password',
                                            border: OutlineInputBorder())),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                SignUpFields.instance
                                                    .registerUser(
                                                        controller.email.text
                                                            .trim(),
                                                        controller.password.text
                                                            .trim());
                                              }
                                              

                                              final user = UserModel(
                                                  firstName: controller
                                                      .firstName.text
                                                      .trim(),
                                                  lastName: controller
                                                      .lastName.text
                                                      .trim(),
                                                  email: controller.email.text
                                                      .trim(),
                                                  password: controller
                                                      .password.text
                                                      .trim());

                                              final firstName = controller
                                                  .firstName.text
                                                  .trim();

                                              UserRepository.instance
                                                  .setFirstName(firstName);

                                              final email =
                                                  controller.email.text.trim();

                                              UserRepository.instance
                                                  .setEmail(email);

                                              setZeroPoints();

                                              SignUpFields.instance
                                                  .createUser(user);
                                            },
                                            style: OutlinedButton.styleFrom(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                foregroundColor: Colors.white,
                                                backgroundColor: Color.fromARGB(
                                                    255, 111, 24, 126)),
                                            child: Text('SIGN UP')))
                                  ])))
                    ]))));
  }
}
