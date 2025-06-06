import 'package:flutter/cupertino.dart';

import 'friends.dart';

class FriendsData extends ChangeNotifier {
  List<Friends> friendsList = [
    // Friends(
    //     firstName: 'Ethan', lastName: 'Umusu', email: 'ethan.umusu@gmail.com'),
  ];

  List<Friends> getFriendsList() {
    return friendsList;
  }

  int numberOfFriends() {
    return friendsList.length;
  }

  void addFriend(String firstName, String lastName, String email) {
    friendsList
        .add(Friends(firstName: firstName, lastName: lastName, email: email));

    notifyListeners();
  }

  void setFriends(List<Friends> friends) {
    friendsList = friends;
    notifyListeners(); 
  }

  
}
