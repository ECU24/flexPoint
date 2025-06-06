import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseType.dart';
import 'package:finalyearproject_flutter_application_1/friends/friends.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  var firstName = ''.obs;

  void setFirstName(String name) {
    firstName.value = name;
  }

  var email = ''.obs;

  void setEmail(String newEmail) {
    email.value = newEmail;
  }

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson());
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    return userData;
  }

  // getUserFirstName(String email) async {
  //   final snapshot =
  //       await _db.collection("Users").where("email", isEqualTo: email).get();

  //   if (snapshot.docs.isEmpty) {
  //     return "User"; // Default fallback if no user is found
  //   }

  //   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
  //   String firstName = userData.firstName.trim();

  //   return firstName; // Assuming `UserModel` has a `firstName` field
  // }

  Future<String> getUserFirstName(String email) async {
    final querySnapshot = await _db
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No user found with this email.');
    }

    return querySnapshot.docs.first['firstName'];
  }

  getUserLastName(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();

    if (snapshot.docs.isEmpty) {
      return "User"; 
    }

    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    print(userData.lastName);
    return userData.lastName; 
  }

  // getUserDocumentId(String email) async {
  //   final snapshot =
  //       await _db.collection("Users").where("Email", isEqualTo: email).get();

  //   if (snapshot.docs.isNotEmpty) {
  //     return snapshot.docs.first.id; // Return the first matching document ID
  //   } else {
  //     return null; // Return null if no document is found
  //   }
  // }

  Future<String?> getUserDocumentId(String email) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      
      if (snapshot.docs.isEmpty) {
        return null; 
      }

      return snapshot.docs.first.id; 
    } catch (e) {
      print("Error fetching user document ID: $e");
      return null;
    }
  }

  createExercise(ExerciseType exercise, String userID) async {
    await _db
        .collection("Users")
        .doc(userID)
        .collection("Exercises")
        .add(exercise.toJson())
        .whenComplete(() => Get.snackbar(
            "Success", "You have added the exercise",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 179, 163, 243),
            colorText: Colors.white));
  }

  Future<String?> getExerciseID(
      String name, String exerciseTypeName, String day, String userID) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(userID)
          .collection("Exercises")
          .where("name", isEqualTo: name)
          .where("day" , isEqualTo: day)
          .where("workout name", isEqualTo: exerciseTypeName)
          .limit(1)
          .get();

      print(name);

      
      if (snapshot.docs.isNotEmpty) {
        return snapshot
            .docs.first.id; 
      } else {
        print("No matching exercise found.");
        return null;
      }
    } catch (e) {
      print("Error fetching exerciseID: $e");
      return null;
    }
  }

  Future<void> updateExerciseRecord(
      ExerciseType exercise, String exerciseID) async {
    await _db.collection("Users").doc(exerciseID).update(exercise.toJson());
  }

  Future<void> createFriend(Friends newFriend, String? userID) async {
    if (userID == null) {
      print("Error: userID is null.");
      return;
    }

    await _db
        .collection("Users")
        .doc(userID)
        .collection("Friends")
        .add(newFriend.toJson())
        .whenComplete(() => Get.snackbar("Success", "Friend has been added!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 179, 163, 243),
            colorText: Colors.white));
  }

  createFriendsList(String? userID) async {
    await _db.collection("Users").doc(userID).collection("Friends");
  }

  Future<int> getLengthFriendsList(String? userID) async {
    final snapshot =
        await _db.collection("Users").doc(userID).collection("Friends").get();
    return snapshot.docs.length;
  }

  Future<bool> checkIfEmailExists(String friendEmail) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where("email", isEqualTo: friendEmail)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<void> completedChallenges(String? userID, String challenge) async {
    final challengeRef =
        _db.collection("Users").doc(userID).collection("CompletedChallenges");

    
    final existing =
        await challengeRef.where('title', isEqualTo: challenge).get();
    if (existing.docs.isEmpty) {
      await challengeRef.add({
        'title': challenge,
        'completedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isChallengeCompleted(
      String userID, String challengeTitle) async {
    final completedChallengesRef =
        _db.collection("Users").doc(userID).collection("CompletedChallenges");

    final snapshot = await completedChallengesRef
        .where('title', isEqualTo: challengeTitle)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
