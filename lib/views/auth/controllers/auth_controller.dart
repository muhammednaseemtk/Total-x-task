import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool isLoading = false;
  bool isLoggedIn = false;
  GoogleSignInAccount? currentUser;
  String? errorMessage;
  List<GoogleSignInAccount> availableAccounts = [];

  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository() {
    initAuthState();
  }

  bool get isLoadingValue => isLoading;
  bool get isLoggedInValue => isLoggedIn;
  GoogleSignInAccount? get currentUserValue => currentUser;
  String? get errorMessageValue => errorMessage;
  List<GoogleSignInAccount> get availableAccountsValue => availableAccounts;

  void initAuthState() {
    _authRepository.authStateChanges.listen((user) {
      isLoggedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> loadAvailableAccounts() async {
    isLoading = true;
    notifyListeners();

    try {
      availableAccounts = await _authRepository.fetchAvailableAccounts();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load accounts';
      availableAccounts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authRepository.signInWithGoogle();
      currentUser = _authRepository.currentGoogleUser;
      isLoggedIn = credential.user != null;
      isLoading = false;
      notifyListeners();
      return isLoggedIn;
    } catch (e) {
      errorMessage = getErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signOut();
      currentUser = null;
      isLoggedIn = false;
    } catch (e) {
      errorMessage = 'Failed to sign out';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAnotherAccount() async {
    await _authRepository.addAnotherAccount();
    availableAccounts = [];
    notifyListeners();
  }

  Future<void> selectAccount(GoogleSignInAccount account) async {
    isLoading = true;
    notifyListeners();

    try {
      await account.clearAuthCache();
      await _authRepository.signInWithGoogle();
      currentUser = _authRepository.currentGoogleUser;
      isLoggedIn = _authRepository.currentUser != null;
    } catch (e) {
      errorMessage = 'Failed to sign in with selected account';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('cancelled') || errorStr.contains('abort')) {
      return 'Sign-in was cancelled';
    }
    return 'Failed to sign in. Please try again.';
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}