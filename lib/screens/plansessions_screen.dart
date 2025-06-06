import 'package:finalyearproject_flutter_application_1/authentication/signup_fields.dart';
import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/screens/mainmenu_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/friday/friday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/saturday/saturday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/signup_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/sunday/sunday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/thursday/thursday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/tuesday/tuesday_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/wednesday/wednesday_screen.dart';
import 'package:flutter/material.dart';

import 'package:finalyearproject_flutter_application_1/screens/monday/monday_screen.dart';
import 'package:get/get.dart';

class PlanSessionsScreen extends StatefulWidget {
  const PlanSessionsScreen({Key? key}) : super(key: key);

  @override
  _PlanSessionsScreen createState() => _PlanSessionsScreen();
}

class _PlanSessionsScreen extends State<PlanSessionsScreen> {
  Map<String, Widget> selectedDays = {
    "Monday": MondayScreen(),
    "Tuesday": TuesdayScreen(),
    "Wednesday": WednesdayScreen(),
    "Thursday": ThursdayScreen(),
    "Friday": FridayScreen(),
    "Saturday": SaturdayScreen(),
    "Sunday": SundayScreen(),
  };

  firstName() async {
    Get.put(SignUpFields());

    final signUpController = Get.find<SignUpFields>();
    String userEmail = signUpController.email.text.trim();

    String? firstName =
        await UserRepository.instance.getUserFirstName(userEmail);

    return firstName;
  }

  Future<void> goToMainMenu(BuildContext context) async {
    String userFirstName = await firstName();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 32, 32, 41),
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 30,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 32, 32, 41),
        ),
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Sessions',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 179, 163, 243),
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Select training days',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: selectedDays.keys.map((day) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 45,
                    width: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => selectedDays[day]!),
                        );
                      },
                      child: Text(
                        day,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: () {
                      goToMainMenu(context);
                    },
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(150, 60),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                    child: Text('DONE',
                        style: TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}

// Generate ListTiles dynamically for each day with spacing
//             Column(
//               children: selectedDays.keys.map((day) {
//                 bool isChecked =
//                     selectedDays[day] ?? false; // Ensure non-null value

//                 return Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: ListTile(
//                         onTap: () {
//                           setState(() {
//                             selectedDays[day] = !isChecked; // Toggle checkbox
//                           });
//                         },
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         tileColor: Colors.white,
//                         leading: Icon(
//                           isChecked
//                               ? Icons.check_box
//                               : Icons.check_box_outline_blank,
//                           color: const Color.fromARGB(255, 179, 163, 243),
//                         ),
//                         title: Text(
//                           day,
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 16),
//                         ),
//                         trailing: Container(
//                           height: 35,
//                           width: 35,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: IconButton(
//                             iconSize: 18,
//                             icon: const Icon(Icons.arrow_forward,
//                                 color: Colors.black),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const MondaySplitChoiceScreen(
//                                             selectedDay: selectedDay)),
//                               );
//                               // Add functionality for the forward button
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15), // Space between tiles
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
