import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/points/points.dart';
import 'package:finalyearproject_flutter_application_1/points/points_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/mainmenu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final controllerPR = Get.put(PointsRepository());
  final controllerUR = Get.put(UserRepository());
  int totalPoints = 0;
  int totalFriends = 0;
  Set<String> completedChallenges = {};

  final _db = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> challenges = [
    {
      'description': 'Reach 30 points to earn 10 bonus points!',
      'type': 'points',
      'target': 30
    },
    {
      'description': 'Reach 50 points to earn 20 bonus points!',
      'type': 'points',
      'target': 50
    },
    {
      'description': 'Add 2 new friends to earn 10 bonus points!',
      'type': 'friends',
      'target': 2
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final userID =
        await controllerUR.getUserDocumentId(controllerUR.email.value);
    final points = await controllerPR.getPoints(userID);
    final friendsCount = await controllerUR.getLengthFriendsList(userID);

    final completedSnap = await _db
        .collection("Users")
        .doc(userID)
        .collection("CompletedChallenges")
        .get();
    completedChallenges =
        completedSnap.docs.map((doc) => doc['title'] as String).toSet();

    setState(() {
      totalPoints = points.points;
      totalFriends = friendsCount;
    });

    _checkChallenges(userID);
  }

  void _checkChallenges(String? userID) async {
    for (var challenge in challenges) {
      final description = challenge['description'];

      if (completedChallenges.contains(description)) {
        continue;
      }

      bool shouldComplete = false;
      int bonusPoints = 0;

      if (challenge['type'] == 'points' && totalPoints >= challenge['target']) {
        shouldComplete = true;
        if (challenge['target'] == 30) {
          bonusPoints = 10;
        } else if (challenge['target'] == 50) {
          bonusPoints = 20;
        }
      }

      if (challenge['type'] == 'friends' &&
          totalFriends >= challenge['target']) {
        shouldComplete = true;
        bonusPoints = 10;
      }

      if (shouldComplete) {
        await controllerUR.completedChallenges(userID, description);

        await controllerPR.addPoints(bonusPoints, userID);

        totalPoints += bonusPoints;
        completedChallenges.add(description);
      }
    }

    setState(() {});
  }

  bool isChallengeCompleted(Map<String, dynamic> challenge) {
    final description = challenge['description'];
    if (completedChallenges.contains(description)) {
      return true;
    }

    if (challenge['type'] == 'points') {
      return totalPoints >= challenge['target'];
    } else if (challenge['type'] == 'friends') {
      return totalFriends >= challenge['target'];
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 32, 41),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainMenuScreen()),
            );
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 32, 32, 41),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "Challenges",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 179, 163, 243),
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 10.0),
              child: Text(
                "Complete Available Challenges Below",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 179, 163, 243),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(30.0),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  final completed = isChallengeCompleted(challenge);

                  return Card(
                    color: const Color.fromARGB(255, 179, 163, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: completed
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.star, color: Colors.amber),
                      title: Text(
                        challenge['description'],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 32, 32, 41),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
