import 'package:finalyearproject_flutter_application_1/screens/login_screen.dart';
import 'package:finalyearproject_flutter_application_1/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 32, 32, 41),
      ),
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('FlexPoint',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 179, 163, 243),
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              Text(
                'No Points.\nNo Gain.',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 45),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            
                              builder: (context) => SignUpScreen()),
                          //builder: (context) => MondayScreen()),
                          //builder: (context) => PlanSessionsScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                      child: Text('START'))),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 111, 24, 126)),
                      child: Text('LOGIN'))),
            ],
          )
        ],
      ),
    ));
  }
}
