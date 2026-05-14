import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  GoogleSignInAccount? get currentGoogleUser;
  Future<List<GoogleSignInAccount>> get signedInAccounts;
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Future<List<GoogleSignInAccount>> fetchAvailableAccounts();
  Future<void> addAnotherAccount();
}