import 'package:finalyearproject_flutter_application_1/authentication/user_repository.dart';
import 'package:finalyearproject_flutter_application_1/friends/friends.dart';
import 'package:finalyearproject_flutter_application_1/friends/friendsData.dart';
import 'package:finalyearproject_flutter_application_1/points/points.dart';
import 'package:finalyearproject_flutter_application_1/points/points_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mainmenu_screen.dart';

class FriendWithPoints {
  final Friends friend;
  final int points;

  FriendWithPoints({required this.friend, required this.points});
}

List<FriendWithPoints> sortedFriends = [];
bool isLoading = true;

class ViewFriendsScreen extends StatefulWidget {
  const ViewFriendsScreen({Key? key}) : super(key: key);
  @override
  State<ViewFriendsScreen> createState() => _ViewFriendsScreenState();
}

class _ViewFriendsScreenState extends State<ViewFriendsScreen> {
  final friendEmailController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    String userEmail = UserRepository.instance.email.value;
    String? userID = await UserRepository.instance.getUserDocumentId(userEmail);

    if (userID != null) {
      var friendsSnapshot =
          await _db.collection("Users").doc(userID).collection("Friends").get();

      List<Friends> friendsList = friendsSnapshot.docs.map((doc) {
        return Friends(
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          email: doc['email'],
        );
      }).toList();

      List<FriendWithPoints> friendsWithPoints = [];
      for (var friend in friendsList) {
        String friendID =
            await UserRepository.instance.getUserDocumentId(friend.email) ?? '';
        var points = await PointsRepository.instance.getPoints(friendID);
        friendsWithPoints
            .add(FriendWithPoints(friend: friend, points: points.points));
      }

      friendsWithPoints.sort((a, b) => b.points.compareTo(a.points));

      setState(() {
        sortedFriends = friendsWithPoints;
        isLoading = false;
      });

      Provider.of<FriendsData>(context, listen: false).setFriends(friendsList);
    }
  }

  void addFriend() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add a new Friend'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      controller: friendEmailController,
                      decoration: InputDecoration(labelText: "Friend's Email")),
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
    String friendEmail = friendEmailController.text.trim();

    if (friendEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    bool emailExists =
        await UserRepository.instance.checkIfEmailExists(friendEmail);
    if (!emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email does not exist in the database.")),
      );
      return;
    }

    String userEmail = UserRepository.instance.email.value;

    String? userID = await UserRepository.instance.getUserDocumentId(userEmail);
    String? firstName =
        await UserRepository.instance.getUserFirstName(friendEmail);
    String? lastName =
        await UserRepository.instance.getUserLastName(friendEmail);

    if (firstName == null || lastName == null || userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Friend not found or invalid.")),
      );
      return;
    }

    final newFriend = Friends(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: friendEmail.trim(),
    );

    await UserRepository.instance.createFriend(newFriend, userID);

    clear();
    Navigator.pop(context);

    await _loadFriends();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    friendEmailController.clear();
  }

  Future<String> getFriendsPoints(String email) async {
    final friendID =
        await UserRepository.instance.getUserDocumentId(email.trim());
    final friendPoints = await PointsRepository.instance.getPoints(friendID);

    return friendPoints.points.toString();
  }

  Future<String> getFriendsName() async {
    final email = friendEmailController.text.trim();

    final friendsName = UserRepository.instance.getUserFirstName(email);

    return friendsName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsData>(
        builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 32, 32, 41),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainMenuScreen()),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: addFriend,
                backgroundColor: Color.fromARGB(255, 179, 163, 243),
                child: Icon(Icons.add, color: Color.fromARGB(255, 32, 32, 41))),
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
                          child: Text("Friends",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 179, 163, 243),
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "View and Add Friends",
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : ListView.builder(
                                itemCount: sortedFriends.length,
                                itemBuilder: (context, index) {
                                  var friendWithPoints = sortedFriends[index];
                                  var friend = friendWithPoints.friend;
                                  var points = friendWithPoints.points;

                                  Widget? medalIcon;
                                  if (index == 0) {
                                    medalIcon = Icon(Icons.emoji_events,
                                        color: Colors.amber, size: 30);
                                  } else if (index == 1) {
                                    medalIcon = Icon(Icons.emoji_events,
                                        color: Colors.grey, size: 30);
                                  } else if (index == 2) {
                                    medalIcon = Icon(Icons.emoji_events,
                                        color: Color(0xFFCD7F32), size: 30);
                                  }

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Material(
                                        color:
                                            Color.fromARGB(255, 179, 163, 243),
                                        child: ListTile(
                                          leading: medalIcon,
                                          title: Text(
                                            "${friend.firstName} ${friend.lastName}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 32, 32, 41),
                                            ),
                                          ),
                                          trailing: Text(
                                            "$points Points",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 32, 32, 41),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )

                      // Expanded(
                      //     child: ListView.builder(
                      //         itemCount: value.numberOfFriends(),
                      //         itemBuilder: (context, index) {
                      //           var friend = value.friendsList[index];
                      //           return Padding(
                      //               padding:
                      //                   const EdgeInsets.only(bottom: 15.0),
                      //               child: ClipRRect(
                      //                   borderRadius:
                      //                       BorderRadius.circular(15.0),
                      //                   child: Material(
                      //                       color: Color.fromARGB(
                      //                           255, 179, 163, 243),
                      //                       child: ListTile(
                      //                         title: Text(
                      //                           "${friend.firstName} ${friend.lastName}",
                      //                           style: TextStyle(
                      //                             fontWeight: FontWeight.bold,
                      //                             fontSize: 18,
                      //                             color: Color.fromARGB(
                      //                                 255, 32, 32, 41),
                      //                           ),
                      //                         ),
                      //                         trailing: FutureBuilder<String>(
                      //                           future: getFriendsPoints(
                      //                               friend.email),
                      //                           builder: (context, snapshot) {
                      //                             if (snapshot
                      //                                     .connectionState ==
                      //                                 ConnectionState.waiting) {
                      //                               return Text(
                      //                                 "...",
                      //                                 style: TextStyle(
                      //                                   fontWeight:
                      //                                       FontWeight.bold,
                      //                                   fontSize: 18,
                      //                                   color: Color.fromARGB(
                      //                                       255, 32, 32, 41),
                      //                                 ),
                      //                               );
                      //                             } else if (snapshot
                      //                                 .hasError) {
                      //                               return Text(
                      //                                 "Err",
                      //                                 style: TextStyle(
                      //                                   fontWeight:
                      //                                       FontWeight.bold,
                      //                                   fontSize: 18,
                      //                                   color: Color.fromARGB(
                      //                                       255, 32, 32, 41),
                      //                                 ),
                      //                               );
                      //                             } else {
                      //                               return Text(
                      //                                 "${snapshot.data ?? "0"} Points",
                      //                                 style: TextStyle(
                      //                                   fontWeight:
                      //                                       FontWeight.bold,
                      //                                   fontSize: 18,
                      //                                   color: Color.fromARGB(
                      //                                       255, 32, 32, 41),
                      //                                 ),
                      //                               );
                      //                             }
                      //                           },
                      //                         ),
                      //                       ))));
                      //         }))
                    ]))));
  }
}
