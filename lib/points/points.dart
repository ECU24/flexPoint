import 'package:cloud_firestore/cloud_firestore.dart';

class Points {
  final int points;

  const Points({required this.points});

  toJson() {
    return {'points': points};
  }

  factory Points.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Points(points: data?["points"]);
  }
}
