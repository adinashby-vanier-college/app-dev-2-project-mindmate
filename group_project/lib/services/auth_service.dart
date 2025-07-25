import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user?.updateDisplayName(username);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      throw e.message ?? 'Sign up failed';
    }
  }

  // Sign in with email and password - IGNORE THE TYPE ERROR
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Caught error: $e');

      // Even if there's a type casting error, check if login actually worked
      await Future.delayed(Duration(milliseconds: 1000));

      if (_auth.currentUser != null && _auth.currentUser!.email == email) {
        print('Login actually succeeded despite the error!');
        return _auth.currentUser;
      }

      // If it's a real authentication error, throw it
      if (e is FirebaseAuthException) {
        throw e.message ?? 'Sign in failed';
      }

      // For the type casting error, just return current user if it exists
      throw 'Login failed - please try again';
    }
  }

  // Google Sign In (we'll disable this for now)
  Future<User?> signInWithGoogle() async {
    throw 'Google Sign In temporarily disabled';
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}