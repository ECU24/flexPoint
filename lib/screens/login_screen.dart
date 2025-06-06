import 'package:flutter/material.dart';
import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:get/get.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpFields());
    final _formKey = GlobalKey<FormState>();

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
                      //Image(image: const AssetImage())
                      const SizedBox(
                        height: 200,
                      ),
                      Text('Welcome Back,',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),

                      Text('Go Gym, Gain Points and Stay Healthy',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),

                      Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                      controller: controller.email,
                                      style: TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.email_outlined),
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
                                        prefixIcon: Icon(Icons.fingerprint),
                                        labelText: 'Password',
                                        hintText: 'Password',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(),
                                      )),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              SignUpFields.instance.loginUser(
                                                  controller.email.text.trim(),
                                                  controller.password.text
                                                      .trim());

                                              final email =
                                                  controller.email.text.trim();

                                              UserRepository.instance
                                                  .setEmail(email);

                                              final firstName =
                                                  await UserRepository.instance
                                                      .getUserFirstName(email);

                                              UserRepository.instance
                                                  .setFirstName(firstName);
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 111, 24, 126)),
                                          child: Text('LOGIN')))
                                ]),
                          ))
                    ]))));
  }
}
