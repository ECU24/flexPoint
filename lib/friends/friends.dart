class Friends {
  String firstName;
  String lastName;
  String email;

  Friends(
      {required this.firstName, required this.lastName, required this.email});

  toJson() {
    return {'firstName': firstName, 'lastName': lastName, 'email': email};
  }
}
