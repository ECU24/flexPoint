// class SignUpWithEmailAndPasswordFailure {
//   final String message;

//   const SignUpWithEmailAndPasswordFailure(
//       [this.message = "An Unknown Error occured."]);

//   factory SignUpWithEmailAndPasswordFailure.code(String code) {
//     switch (code) {
//       case 'weak-password':
//         return const SignUpWithEmailAndPasswordFailure(
//             "Please enter stronger password.");
//       case 'invaild-email':
//         return const SignUpWithEmailAndPasswordFailure(
//             "Email address is invalid or badly formatted");
//       case 'email-already-in-use':
//         return const SignUpWithEmailAndPasswordFailure("Email already in use");
//       default:
//         return const SignUpWithEmailAndPasswordFailure();
//     }
//   }
// }

class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An Unknown Error occurred."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
            "Please enter a stronger password.");
      case 'invalid-email': 
        return const SignUpWithEmailAndPasswordFailure(
            "Email address is invalid or badly formatted.");
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
            "Email is already in use. Try logging in instead.");
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
