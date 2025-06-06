import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_model.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseData.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseType.dart';
import 'package:finalyearproject_flutter_application_1/data/exercises.dart';
import 'package:finalyearproject_flutter_application_1/screens/plansessions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/signup_screen.dart';

class ExerciseEditScreen extends StatefulWidget {
  final String exerciseTypeName;
  const ExerciseEditScreen({super.key, required this.exerciseTypeName});

  @override
  State<ExerciseEditScreen> createState() => _ExerciseEditScreenState();
}

class _ExerciseEditScreenState extends State<ExerciseEditScreen> {
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  final userRepo = Get.put(UserRepository());

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add a new exercise'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      controller: exerciseNameController,
                      decoration: InputDecoration(labelText: 'Exercise Name')),
                  TextField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)')),
                  TextField(
                      controller: repsController,
                      decoration: InputDecoration(labelText: 'Reps')),
                  TextField(
                      controller: setsController,
                      decoration: InputDecoration(labelText: 'Sets')),
                ]),
                actions: [
                  MaterialButton(
                    onPressed: save,
                    child: Text("save"),
                  ),
                  MaterialButton(onPressed: cancel, child: Text("cancel")),
                ]));
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

    Provider.of<ExerciseData>(context, listen: false).addExercise(
        widget.exerciseTypeName, newExerciseName, weight, reps, sets);

    final newExercise = ExerciseType(
      name: exerciseTypeName.trim(),
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
      String weight, String reps, String sets, String day) {
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
                    Provider.of<ExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "name",
                            _nameController.text);
                    Provider.of<ExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "weight",
                            _weightController.text);
                    Provider.of<ExerciseData>(context, listen: false)
                        .modifyExercise(exerciseTypeName, index, "reps",
                            _repsController.text);
                    Provider.of<ExerciseData>(context, listen: false)
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

  Map<int, bool> checkedItems = {};

  Widget build(BuildContext context) {
    return Consumer<ExerciseData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 32, 32, 41),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlanSessionsScreen()),
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
                        "Choose Exercise",
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
                                          exercise.sets,
                                          "Monday"),
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
                                                ))),
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
                                      trailing: Checkbox(
                                        value: checkedItems[index] ?? false,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            checkedItems[index] =
                                                newValue ?? false;
                                          });
                                        },
                                        activeColor:
                                            Color.fromARGB(255, 32, 32, 41),
                                        checkColor: Colors.white,
                                      )),
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
