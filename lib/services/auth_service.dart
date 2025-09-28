import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    // Debug: Check if Firebase Auth is properly configured
    print("🔥 AuthService created");
    print("🔥 FirebaseAuth.instance.app: ${_auth.app.name}");
    print("🔥 FirebaseAuth.instance.app.options: ${_auth.app.options}");
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      print("🔥 Attempting sign in with: $email");
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      print("✅ Sign in successful: ${result.user?.email}");
      return result.user;
    } catch (e) {
      print('❌ Sign in error: $e');
      return null;
    }
  }

  // Register with email, password, and display name
  Future<User?> register(String email, String password, String fullName) async {
    try {
      print("🔥 Attempting registration with: $email, $fullName");
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      print("✅ Registration successful: ${result.user?.email}");
      
      // Update display name
      if (fullName.isNotEmpty) {
        await result.user?.updateDisplayName(fullName);
        await result.user?.reload();
        print("✅ Display name updated to: $fullName");
      }
      return _auth.currentUser;
    } catch (e) {
      print('❌ Registration error: $e');
      print('❌ Error details: ${e.toString()}');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}