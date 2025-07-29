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

  // Sign in with email and password - PROPERLY FIXED
  Future<User?> signIn(String email, String password) async {
    try {
      // First, make sure we're signed out to avoid confusion
      await _auth.signOut();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors properly
      print('Firebase auth error: ${e.code} - ${e.message}');

      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email';
        case 'wrong-password':
          throw 'Incorrect password';
        case 'invalid-email':
          throw 'Invalid email address';
        case 'user-disabled':
          throw 'This user account has been disabled';
        case 'invalid-credential':
          throw 'Invalid email or password';
        case 'too-many-requests':
          throw 'Too many login attempts. Please try again later';
        default:
          throw e.message ?? 'Login failed';
      }
    } catch (e) {
      // Handle the type casting error specifically
      if (e.toString().contains('PigeonUserDetails')) {
        print('Type casting error detected, checking auth state...');

        // Wait a moment for auth state to settle
        await Future.delayed(Duration(milliseconds: 1000));

        // CRITICAL: Only return user if they match the email being used to login
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.email?.toLowerCase() == email.toLowerCase()) {
          print('Login succeeded despite type casting error');
          return currentUser;
        } else {
          // If no user or wrong user, the login actually failed
          await _auth.signOut(); // Make sure we're signed out
          throw 'Login failed - invalid credentials';
        }
      }

      // For any other errors, make sure we're signed out and throw
      await _auth.signOut();
      throw e.toString();
    }
  }

  // Google Sign In (disabled for now)
  Future<User?> signInWithGoogle() async {
    throw 'Google Sign In temporarily disabled';
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}