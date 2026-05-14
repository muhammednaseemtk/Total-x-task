import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => auth.authStateChanges();

  User? get currentUser => auth.currentUser;

  GoogleSignInAccount? get currentGoogleUser => googleSignIn.currentUser;

  Future<List<GoogleSignInAccount>> get signedInAccounts async {
    final result = await googleSignIn.signInSilently();
    return result != null ? [result] : [];
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  Future<List<GoogleSignInAccount>> fetchAvailableAccounts() async {
    try {
      final result = await googleSignIn.signInSilently();
      return result != null ? [result] : [];
    } catch (e) {
      return [];
    }
  }

  Future<void> addAnotherAccount() async {
    await googleSignIn.signOut();
  }
}