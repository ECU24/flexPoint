import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/points/points_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/mainmenu_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsQuestion extends StatelessWidget {
  const PointsQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerPR = Get.put(PointsRepository());
    final controllerUR = Get.put(UserRepository());

    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 32, 32, 41),
          ),
          padding: EdgeInsets.all(30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have you attended the gym today?',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: const Color.fromARGB(255, 179, 163, 243),
                            fontSize: 45,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainMenuScreen()),
                              );
                              final email = controllerUR.email.value;

                              String? userID =
                                  await controllerUR.getUserDocumentId(email);

                              controllerPR.removePoints(10, userID);
                            },
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(255, 111, 24, 126)),
                            child: Text('NO'))),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainMenuScreen()),
                              );

                              final email = controllerUR.email.value;

                              String? userID =
                                  await controllerUR.getUserDocumentId(email);

                              controllerPR.addPoints(10, userID);
                            },
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(255, 111, 24, 126)),
                            child: Text('YES'))),
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainMenuScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(255, 179, 163, 243)),
                          child: Text('SKIP'))),
                ])
              ])),
    );
  }
}
