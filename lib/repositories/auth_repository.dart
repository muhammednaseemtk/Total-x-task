import '../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  GoogleSignInAccount? get currentGoogleUser => _authService.currentGoogleUser;

  Future<UserCredential> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<List<GoogleSignInAccount>> fetchAvailableAccounts() async {
    return await _authService.fetchAvailableAccounts();
  }

  Future<void> addAnotherAccount() async {
    await _authService.addAnotherAccount();
  }
}
