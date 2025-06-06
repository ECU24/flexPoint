import 'package:finalyearproject_flutter_application_1/authentication/authentication_repository.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/points/points.dart';
import 'package:finalyearproject_flutter_application_1/points/points_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/challenge_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/plansessions_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/pointsQuestion_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/viewFriends_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final controllerPR = Get.put(PointsRepository());
  final controllerUR = Get.put(UserRepository());
  final controllerAR = Get.put(AuthenticationRepository());

  Future<Points>? _pointsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPoints();
  }

  // Future<void> getFirstName() async {
  //   final email = controllerUR.email.value;
  //   String firstName = controllerUR.getUserFirstName(email);
  //   // return firstName;
  // }

  void _refreshPoints() {
    setState(() {
      _pointsFuture = getPoints();
    });
  }

  Future<Points> getPoints() async {
    final email = controllerUR.email.value;
    final userID = await controllerUR.getUserDocumentId(email);
    final points = await controllerPR.getPoints(userID);
    return points;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(Icons.menu, color: Colors.white),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white),
          color: Color.fromARGB(255, 54, 54, 64),
          onSelected: (value) {
            if (value == 'signout') {
              controllerAR
                  .logout(); // assuming your UserRepository has a signOut() method
              // or Navigator.pushReplacement to your login screen
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'signout',
              child: Text('Sign Out',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
        title: Text("FlexPoint",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 179, 163, 243),
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 32, 32, 41),
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 32, 32, 41),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome, ${UserRepository.instance.firstName.value}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 179, 163, 243),
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Points",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<Points>(
                        future: _pointsFuture,
                        builder: (context, snapshot) {
                          final totalPoints = snapshot.data?.points ?? 0;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$totalPoints",
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 179, 163, 243),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.refresh, color: Colors.white),
                                onPressed: _refreshPoints,
                              ),
                            ],
                          );
                        },
                      )
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlanSessionsScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(90, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                        child: Text('Edit Plan',
                            style: const TextStyle(fontSize: 20))),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PointsQuestion()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(90, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                        child: Text('Points',
                            style: const TextStyle(fontSize: 20))),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewFriendsScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(90, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                        child: Text('View Friends',
                            style: const TextStyle(fontSize: 20))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 90.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChallengesScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(180, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 111, 24, 126),
                    ),
                    child: const Text(
                      "Challenges",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ])),
    );
  }
}
