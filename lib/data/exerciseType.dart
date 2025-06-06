import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercises.dart';

class ExerciseType {
  final String? id;
  final String name;
  final String? day;
  final List<Exercise> exercises;

  const ExerciseType(
      {this.id, required this.name, this.day, required this.exercises});

  toJson() {
    return {
      'workout name': name,
      'day': day,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList()
    };
  }

  factory ExerciseType.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return ExerciseType(
        id: document.id,
        name: data["workout name"],
        exercises: data["exercises"]);
  }
}
