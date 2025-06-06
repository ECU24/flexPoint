import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject_flutter_application_1/points/points.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsRepository extends GetxController {
  static PointsRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  setPoints(Points points, String? userID) async {
    await _db
        .collection("Users")
        .doc(userID)
        .collection("Points")
        .doc("userPoints")
        .set(points.toJson(), SetOptions(merge: true));
  }

  // Future<Points> getPoints(String? userID) async {
  //   final snapshot = await _db
  //       .collection("Users")
  //       .doc(userID)
  //       .collection("Points")
  //       .doc("userPoints")
  //       .get();

  //   if (snapshot.docs.isEmpty) {
  //     print("empty");
  //   }

  //   //final points = Points.fromSnapshot(snapshot.docs.first);

  //   final points = snapshot.docs.map((e) => Points.fromSnapshot(e)).single;
  //   print(points.points.toString());
  //   return points;
  // }

  Future<Points> getPoints(String? userID) async {
    if (userID == null || userID.isEmpty) {
      print("User ID is empty.");
      throw Exception("User ID is empty");
    }

    try {
      final docRef = _db
          .collection("Users")
          .doc(userID)
          .collection("Points")
          .doc("userPoints");

      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        print("No points document found.");
        throw Exception("No points document found.");
      }

      final points = Points.fromSnapshot(snapshot);

      print(points.points.toString());

      return points;
    } catch (e) {
      print("Error getting points: $e");
      rethrow;
    }
  }

//   Future<void> addPoints(String points, String? userID) async {
//     if (userID!.isEmpty || points.isEmpty) {
//       print("User ID or points is empty.");
//       return;
//     }

//     try {
//       final docRef = _db
//           .collection("Users")
//           .doc(userID)
//           .collection("Points")
//           .doc("userPoints"); // Use a specific doc name or dynamic ID

//       // Check if the document exists
//       final docSnapshot = await docRef.get();

//       if (docSnapshot.exists) {
//         // Update existing points
//         await docRef.update({
//           "points": FieldValue.increment(int.parse(points)),
//         });
//         print("Points updated by $points.");
//       } else {
//         // Create the document if it doesn't exist
//         await docRef.set({
//           "points": int.parse(points),
//         });
//         print("New points document created with $points.");
//       }
//     } catch (e) {
//       print("Error updating points: $e");
//     }
//   }
// }

  Future<void> addPoints(int points, String? userID) async {
    if (userID == null || userID.isEmpty) {
      print("User ID is empty.");
      return;
    }

    if (points <= 0) {
      print("Points must be greater than 0.");
      return;
    }

    try {
      final docRef = _db
          .collection("Users")
          .doc(userID)
          .collection("Points")
          .doc("userPoints");

      await _db.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);

        if (docSnapshot.exists) {
          transaction.update(docRef, {
            "points": FieldValue.increment(points),
          });
          print("Points updated by $points.");
        } else {
          transaction.set(docRef, {
            "points": points,
          });
          print("New points document created with $points.");
        }
      });
    } catch (e) {
      print("Error updating points: $e");
    }
  }

  Future<void> removePoints(int points, String? userID) async {
    if (userID == null || userID.isEmpty) {
      print("User ID is empty.");
      return;
    }

    try {
      final docRef = _db
          .collection("Users")
          .doc(userID)
          .collection("Points")
          .doc("userPoints");

      await _db.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);

        if (!docSnapshot.exists) {
          print("Points document does not exist.");
          return;
        }

        final currentPoints = docSnapshot.data()?['points'] ?? 0;

        if (currentPoints <= 0) {
          print("User has no points or is in a negative balance.");
          return;
        }

        final newPoints = currentPoints - points;

        if (newPoints < 0) {
          print("Cannot remove $points points. User only has $currentPoints.");
          transaction.update(docRef, {"points": 0});
        } else {
          transaction.update(docRef, {"points": newPoints});
          print("$points points removed. New total: $newPoints.");
        }
      });
    } catch (e) {
      print("Error removing points: $e");
    }
  }
}
