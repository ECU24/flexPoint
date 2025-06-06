import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_model.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseData.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseType.dart';
import 'package:finalyearproject_flutter_application_1/data/exercises.dart';
import 'package:finalyearproject_flutter_application_1/screens/monday/monday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/plansessions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/signup_screen.dart';

class MondayExerciseEditScreen extends StatefulWidget {
  final String exerciseTypeName;
  const MondayExerciseEditScreen({super.key, required this.exerciseTypeName});

  @override
  State<MondayExerciseEditScreen> createState() =>
      _MondayExerciseEditScreenState();
}

class _MondayExerciseEditScreenState extends State<MondayExerciseEditScreen> {
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  String day = "Monday";

  final userRepo = Get.put(UserRepository());

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // List<String> presetExerciseNames = [
  //   'Incline Bench',
  //   'Incline Dumbbell Press',
  //   'Cable Flys',
  //   'Bench Press',
  //   'Duumbbell Press',
  //   'Machine Press',
  // ];

  final Map<String, List<String>> presetExercisesByType = {
    'Chest': [
      'Bench Press',
      'Incline Dumbbell Press',
      'Chest Fly',
      'Machine Press',
      'Dumbbell Press',
      'Cable Fly'
    ],
    'Back': [
      'Pull-Up',
      'Lat Pulldown',
      'Cable Row',
      'Dumbbell Row',
      'T-Bar Row',
      'Barbell Rows'
    ],
    'Legs': [
      'Squats',
      'Leg Press',
      'Lunges',
      'Leg Curl',
      'Leg Extension',
      'Hip Thrust'
    ],
    'Shoulders': [
      'Shoulder Press',
      'Lateral Raise',
      'Front Raise',
      'Face Pull',
      'Barbell Press'
    ],
    'Biceps': [
      'Bicep Curl',
      'Hammer Curl',
      'Incline Bicep Curls',
      'Preacher Curls'
    ],
    'Triceps': [
      'Tricep Pushdown',
      'Tricep Extensions',
      'Overhead Extensions',
      'Skull Crushers'
    ],
    'Abs': [
      'Cable Crunch',
      'Leg Raises',
    ],
  };

  @override
  void initState() {
    super.initState();
    fetchExercisesFromFirebase();
  }

  void fetchExercisesFromFirebase() async {
    final controllerUR = Get.put(UserRepository());
    String userEmail = controllerUR.email.value;
    String? userID = await UserRepository.instance.getUserDocumentId(userEmail);

    if (userID == null) {
      print("No user ID found");
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .collection("Exercises")
          .where("day", isEqualTo: "Monday")
          .where("workout name", isEqualTo: widget.exerciseTypeName)
          .get();

      final exercises = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Exercise.fromMap(data);
      }).toList();

      final provider = Provider.of<MondayExerciseData>(context, listen: false);

      for (var exercise in exercises) {
        provider.addExercise(
          widget.exerciseTypeName.trim(),
          exercise.name.trim(),
          exercise.weight.trim(),
          exercise.reps.trim(),
          exercise.sets.trim(),
        );

        //print("Firebase Exercise Data: ${data.toString()}");
        print("Found ${snapshot.docs.length} exercises in Firebase");
      }

      Provider.of<MondayExerciseData>(context, listen: false)
          .getExerciseList()
          .forEach((type) {
        print("ExerciseType: ${type.name}");
        type.exercises.forEach((ex) {
          print(
              " - ${ex.name} (${ex.weight}kg, ${ex.reps} reps, ${ex.sets} sets)");
        });
      });

      setState(() {});
    } catch (e) {
      print("Error fetching exercises: $e");
    }

    print("Fetching exercises for type: ${widget.exerciseTypeName}");
    print("UserID: $userID");
  }

  String selectedExerciseName = '';

  void createNewExercise() {
    final List<String> presetExerciseNames =
        presetExercisesByType[widget.exerciseTypeName] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a new exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return presetExerciseNames;
                  }
                  return presetExerciseNames.where((String option) {
                    return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                  });
                },
                onSelected: (String selection) {
                  exerciseNameController.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  exerciseNameController.text = fieldTextController.text;
                  fieldTextController.addListener(() {
                    exerciseNameController.text = fieldTextController.text;
                  });

                  Future.delayed(Duration.zero, () {
                    fieldFocusNode.requestFocus();
                  });

                  return TextField(
                    controller: fieldTextController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(labelText: 'Exercise Name'),
                    onTap: () {
                      if (fieldTextController.text.isEmpty) {
                        fieldTextController.text = ' ';
                        fieldTextController.clear();
                      }
                    },
                  );
                },
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps'),
              ),
              TextField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Sets'),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text("save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("cancel"),
          ),
        ],
      ),
    );
  }

  void save() async {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    if (newExerciseName.isEmpty ||
        weight.isEmpty ||
        reps.isEmpty ||
        sets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    String exerciseTypeName = widget.exerciseTypeName;

    Get.put(SignUpFields());

    final signUpController = Get.find<SignUpFields>();
    String userEmail = signUpController.email.text.trim();
    print("User email: $userEmail");

    String? userID = await UserRepository.instance.getUserDocumentId(userEmail);

    if (userID == null) {
      print("Error: No user found with this email.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No user found with this email.")),
      );
      return;
    }

    Provider.of<MondayExerciseData>(context, listen: false).addExercise(
        widget.exerciseTypeName, newExerciseName, weight, reps, sets);

    final newExercise = ExerciseType(
      name: exerciseTypeName.trim(),
      day: day.trim(),
      exercises: [
        Exercise(
          name: newExerciseName.trim(),
          weight: weight.trim(),
          reps: reps.trim(),
          sets: sets.trim(),
        )
      ],
    );

    await UserRepository.instance.createExercise(newExercise, userID);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void updateRecord(ExerciseType exercise, String exerciseID) async {
    await userRepo.updateExerciseRecord(exercise, exerciseID);
  }

  void editExercise(int index, String exerciseTypeName, String name,
      String weight, String reps, String sets) {
    _nameController.text = name;
    _weightController.text = weight;
    _repsController.text = reps;
    _setsController.text = sets;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Exercise Name')),
                  TextField(
                      controller: _weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)')),
                  TextField(
                      controller: _repsController,
                      decoration: InputDecoration(labelText: 'Reps')),
                  TextField(
                      controller: _setsController,
                      decoration: InputDecoration(labelText: 'Sets')),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    Provider.of<MondayExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "name",
                            _nameController.text);
                    Provider.of<MondayExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "weight",
                            _weightController.text);
                    Provider.of<MondayExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "reps",
                            _repsController.text);
                    Provider.of<MondayExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "sets",
                            _setsController.text);

                    final signUpController = Get.find<SignUpFields>();
                    String userEmail = signUpController.email.text.trim();
                    String? userID = await UserRepository.instance
                        .getUserDocumentId(userEmail);

                    if (userID == null || userID.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: User not found.")));
                      return;
                    }

                    String? exerciseID = await UserRepository.instance
                        .getExerciseID(name, exerciseTypeName, userID, day);
                    if (exerciseID == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error: Exercise not found.")));
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(userID)
                          .collection("Exercises")
                          .doc(exerciseID)
                          .update({
                        "name": _nameController.text.trim(),
                        "weight": _weightController.text.trim(),
                        "reps": _repsController.text.trim(),
                        "sets": _setsController.text.trim(),
                      });

                      print("Exercise successfully updated!");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Exercise updated successfully!")));
                      Navigator.pop(context);
                    } catch (error) {
                      print("Error updating Firestore: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error updating exercise.")));
                    }

                    setState(() {});
                    //Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            ));
  }

  void deleteExercise(
      String name, String exerciseTypeName, String day, int index) async {
    final signUpController = Get.find<SignUpFields>();
    // String userEmail = signUpController.email.text.trim();
    String userEmail = UserRepository.instance.email.value;
    String? userID = await UserRepository.instance.getUserDocumentId(userEmail);

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: User not found.")),
      );
      return;
    }

    String? exerciseID = await UserRepository.instance.getExerciseID(
      name,
      exerciseTypeName,
      userID,
      day,
    );

    if (exerciseID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Exercise not found.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .collection("Exercises")
          .doc(exerciseID)
          .delete();

      Provider.of<MondayExerciseData>(context, listen: false)
          .removeExercise(exerciseTypeName, index);

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting exercise: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting exercise.")),
      );
    }
  }

  Map<int, bool> checkedItems = {};

  Widget build(BuildContext context) {
    return Consumer<MondayExerciseData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 32, 32, 41),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MondayScreen()),
                    );
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: createNewExercise,
                  backgroundColor: Color.fromARGB(255, 179, 163, 243),
                  child:
                      Icon(Icons.add, color: Color.fromARGB(255, 32, 32, 41))),
              body: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 32, 32, 41),
                ),
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exerciseTypeName,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 179, 163, 243),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Add and Edit Exercises",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.numberOfExercisesInExerciseType(
                              widget.exerciseTypeName),
                          itemBuilder: (context, index) {
                            var exercise = value
                                .getRelevantExerciseType(
                                    widget.exerciseTypeName)
                                .exercises[index];
                            print(
                                "Tile: ${exercise.name}, ${exercise.weight}, ${exercise.reps}, ${exercise.sets}");

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Material(
                                  color: Color.fromARGB(255, 179, 163, 243),
                                  child: ListTile(
                                    onTap: () => editExercise(
                                        index,
                                        widget.exerciseTypeName,
                                        exercise.name,
                                        exercise.weight,
                                        exercise.reps,
                                        exercise.sets),
                                    title: Text(exercise.name,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 32, 32, 41),
                                          fontWeight: FontWeight.bold,
                                        )),

                                    // style:
                                    //     TextStyle(decoration: TextDecoration.underline)),
                                    subtitle: Row(children: [
                                      Chip(
                                          label: Text("${exercise.weight}kg",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 32, 32, 41),
                                                fontWeight: FontWeight.bold,
                                              ))
                                          //backgroundColor: ,
                                          ),
                                      Chip(
                                          label: Text("${exercise.reps} reps",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 32, 32, 41),
                                                fontWeight: FontWeight.bold,
                                              ))),
                                      Chip(
                                          label: Text("${exercise.sets} sets",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 32, 32, 41),
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ]),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 32, 32, 41)),
                                          onPressed: () => deleteExercise(
                                              exercise.name,
                                              widget.exerciseTypeName,
                                              "Monday",
                                              index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ));
  }
}
