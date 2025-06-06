import 'package:finalyearproject_flutter_application_1/data/exerciseData.dart';
import 'package:finalyearproject_flutter_application_1/screens/plansessions_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/sunday/sunday_editScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exerciseEdit_screen.dart';

class SundayScreen extends StatefulWidget {
  const SundayScreen({Key? key}) : super(key: key);

  @override
  _SundayScreen createState() => _SundayScreen();
}

class _SundayScreen extends State<SundayScreen> {
  void goToExerciseEdit_screen(String exerciseTypeName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SundayExerciseEditScreen(
            exerciseTypeName: exerciseTypeName,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SundayExerciseData>(
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
            body: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 32, 32, 41),
              ),
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Text(
                      "Sunday Split",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 179, 163, 243),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Choose Workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.getExerciseList().length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Material(
                              color: Color.fromARGB(255, 179, 163, 243),
                              child: ListTile(
                                title: Text(
                                  value.getExerciseList()[index].name,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 32, 32, 41),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () => goToExerciseEdit_screen(
                                      value.getExerciseList()[index].name),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
