import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';

Future<Map<String, dynamic>> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential cred =
      await FirebaseAuth.instance.signInWithCredential(credential);
  String email = cred.user?.email ?? '';
  bool res = await findUser({'email': email});
  if (!res) {
    String name = cred.user?.displayName ?? email;

    var response = await registerRequest(
        {'email': email, 'username': name, 'password': 'password'});

    if (response['success']) {
      return response;
    }
  } else {
    var response = await socialLoginRequest({'email': email});

    if (response['success']) {
      return response;
    }
  }
  return {'success': false};
}
