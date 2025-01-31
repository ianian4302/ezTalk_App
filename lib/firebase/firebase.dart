// import 'package:firebase_auth/firebase_auth.dart' as FBA;
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginAuthRepository {
//   final GoogleSignIn googleSignIn;
//   final FBA.FirebaseAuth firebaseAuth;

//   LoginAuthRepository({required this.googleSignIn, required this.firebaseAuth});

//   FBA.User? getUser() {
//     try {
//       return firebaseAuth.currentUser;
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     GoogleSignInAuthentication? googleAuth;
//     try {
//       bool isSignedIn = await this.googleSignIn.isSignedIn();
//       if (!isSignedIn) {
//         final GoogleSignInAccount? googleUser =
//             await this.googleSignIn.signIn();
//         // Obtain the auth details from the request
//         googleAuth = await googleUser?.authentication;
//       } else {
//         GoogleSignInAccount? googleUser = await this.googleSignIn.signOut();
//         googleUser = await this.googleSignIn.signIn();
//         // Obtain the auth details from the request
//         googleAuth = await googleUser?.authentication;
//       }
//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//       return FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (error) {
//       throw error;
//     }
//   }
// }
