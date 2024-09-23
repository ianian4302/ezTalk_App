// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
// final FirebaseFirestore db = FirebaseFirestore.instance;

// Future<void> signIn() async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//   if (googleUser != null) {
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     UserCredential userCredential = await auth.signInWithCredential(credential);
//     User? userInfo = userCredential.user;

//     String userName = userInfo?.email?.split('@')[0] ?? '';
//     String email = userInfo?.email ?? '';
//     String password = userInfo?.uid ?? '';

//     Map<String, dynamic> data = {
//       'username': userName,
//       'email': email,
//       'password': password,
//     };

//     print(data);
//     await signup(data);
//     localStorage.setItem("user", userName);
//     print("Signed In");
//     // Navigate to the desired page
//   }
// }

// Future<void> signup(Map<String, dynamic> data) async {
//   print("=======================");
//   try {
//     final response = await http.post(
//       Uri.parse("https://120.126.151.159:56432/api/sign-up"),
//       headers: {
//         "Content-Type": "application/json",
//         "Access-Control-Allow-Origin": "*",
//       },
//       body: jsonEncode(data),
//     );
//     // Handle response
//   } catch (error) {
//     print(error);
//   }
// }

// Future<void> signOut() async {
//   await auth.signOut();
//   print("Signed Out");
//   localStorage.removeItem("user");
//   // Navigate to the desired page
// }
