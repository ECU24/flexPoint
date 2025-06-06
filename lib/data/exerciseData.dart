import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'exercises.dart';
import 'exerciseType.dart';

class ExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  // void addExercise(String exerciseTypeName, String exerciseName, String weight,
  //     String reps, String sets) {
  //   // Try to find an existing ExerciseType with the same name
  //   ExerciseType? existing = exerciseList.firstWhere(
  //     (e) => e.name == exerciseTypeName,
  //     orElse: () =>
  //         ExerciseType(name: exerciseTypeName, day: "Monday", exercises: []),
  //   );

  //   // Add the new exercise to the exercises list
  //   existing.exercises.add(
  //     Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
  //   );

  //   // If this is a new type, add it to the list
  //   if (!exerciseList.contains(existing)) {
  //     exerciseList.add(existing);
  //   }

  //   notifyListeners();
  // }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class MondayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Monday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void removeExercise(String exerciseTypeName, int index) {
    print(
        "Available exercise types: ${exerciseList.map((e) => e.name).toList()}");
    final exerciseType = exerciseList.firstWhere(
      (et) => et.name.trim() == exerciseTypeName.trim(),
    );

    if (exerciseType == null) {
      print("No matching exercise type found for $exerciseTypeName");
      return;
    }

    if (index >= 0 && index < exerciseType.exercises.length) {
      exerciseType.exercises.removeAt(index);
      notifyListeners();
    } else {
      print("Invalid exercise index: $index");
    }
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

// find relveant exercise type, given exercise type name
  // ExerciseType getRelevantExerciseType(String exerciseTypeName) {
  //   ExerciseType relevantExerciseType = exerciseList
  //       .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

  //   return relevantExerciseType;
  // }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    return exerciseList.firstWhere(
      (exerciseType) => exerciseType.name == exerciseTypeName,
      orElse: () {
        final newType =
            ExerciseType(name: exerciseTypeName, day: "Monday", exercises: []);
        exerciseList.add(newType);
        return newType;
      },
    );
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class TuesdayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Tuesday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class WednesdayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Wednesday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class ThursdayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Thusrday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class FridayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Friday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class SaturdayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Saturday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

class SundayExerciseData extends ChangeNotifier {
  List<ExerciseType> exerciseList = [
    //default workout
    ExerciseType(
      name: "Chest",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Chest Press (DEFAULT)",
          weight: "44",
          reps: "8",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Shoulders",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Lateral Raise (DEFAULT)",
          weight: "14",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Biceps",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Bicep Curls (DEFAULT)",
          weight: "18",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Triceps",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Tricep Extensions (DEFAULT)",
          weight: "20",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Legs",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Leg Press (DEFAULT)",
          weight: "140",
          reps: "12",
          sets: "3",
        )
      ],
    ),

    ExerciseType(
      name: "Abs",
      day: "Sunday",
      exercises: [
        Exercise(
          name: "Cable Crunch (DEFAULT)",
          weight: "30",
          reps: "12",
          sets: "3",
        )
      ],
    )
  ];

  List<ExerciseType> getExerciseList() {
    return exerciseList;
  }

  int numberOfExercisesInExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    return relevantExerciseType.exercises.length;
  }

  void addExercise(String exerciseTypeName, String exerciseName, String weight,
      String reps, String sets) {
    // ExerciseType relevantWorkout = exerciseList
    //     .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    ExerciseType relevantWorkout = getRelevantExerciseType(exerciseTypeName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
  }

  void tickOffExercise(String exerciseTypeName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(exerciseTypeName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  void modifyExercise(
      String exerciseTypeName, int index, String field, String newValue) {
    var exerciseType = getRelevantExerciseType(exerciseTypeName);
    var exercise = exerciseType.exercises[index];

    if (field == "name") {
      exercise.name = newValue;
    } else if (field == "weight") {
      exercise.weight = newValue;
    } else if (field == "reps") {
      exercise.reps = newValue;
    } else if (field == "sets") {
      exercise.sets = newValue;
    }

    notifyListeners();
  }

  ExerciseType getRelevantExerciseType(String exerciseTypeName) {
    ExerciseType relevantExerciseType = exerciseList
        .firstWhere((exerciseType) => exerciseType.name == exerciseTypeName);

    return relevantExerciseType;
  }

  Exercise getRelevantExercise(String exerciseTypeName, String exerciseName) {
    ExerciseType relevantExerciseType =
        getRelevantExerciseType(exerciseTypeName);

    Exercise relevantExercise = relevantExerciseType.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
