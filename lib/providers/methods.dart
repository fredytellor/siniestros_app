import 'package:firebase_auth/firebase_auth.dart';

class Methods {
  
  Future<bool> consultarInicioEmail(String email) async {
    try {
      var result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
      if (result.contains('password')) {
        print(result);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
