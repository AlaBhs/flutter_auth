import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  
  String email = '';
  String password = '';
  String fullName = '';
  bool isLoading = false;
  bool isLogin = true;
  bool _obscurePassword = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      User? user;
      String operation = isLogin ? 'Login' : 'Registration';
      
      if (isLogin) {
        user = await _auth.signIn(email, password);
      } else {
        user = await _auth.register(email, password, fullName);
      }
      
      if (user != null) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$operation successful!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          )
        );
        
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen(user: user!))
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$operation failed. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          )
        );
      }
      
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header Section
                        Column(
                          children: [
                            // Logo/Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.radio,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Title
                            Text(
                              'Babylon Radio',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Subtitle
                            Text(
                              isLogin ? 'Welcome back!' : 'Create your account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Form Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  if (!isLogin) 
                                    _buildTextField(
                                      Icons.person_outline,
                                      'Full Name',
                                      'Enter your full name',
                                      (value) => fullName = value!,
                                      validator: (value) => value!.isEmpty ? 'Required' : null,
                                    ),
                                  
                                  if (!isLogin) const SizedBox(height: 16),
                                  
                                  _buildTextField(
                                    Icons.email_outlined,
                                    'Email',
                                    'Enter your email',
                                    (value) => email = value!,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Email is required';
                                      if (!value.contains('@')) return 'Enter a valid email';
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  _buildTextField(
                                    Icons.lock_outline,
                                    'Password',
                                    'Enter your password',
                                    (value) => password = value!,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Password is required';
                                      if (value.length < 6) return 'Password must be at least 6 characters';
                                      return null;
                                    },
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Submit Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: isLoading 
                                      ? const Center(child: CircularProgressIndicator())
                                      : ElevatedButton(
                                          onPressed: _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            isLogin ? 'Sign In' : 'Create Account',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Switch between login/register
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isLogin 
                                            ? "Don't have an account?"
                                            : "Already have an account?",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isLogin = !isLogin;
                                            if (isLogin) fullName = '';
                                          });
                                        },
                                        child: Text(
                                          isLogin ? 'Sign Up' : 'Sign In',
                                          style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Footer
                        const Text(
                          'By continuing, you agree to our Terms of Service',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String label,
    String hint,
    ValueChanged<String> onChanged, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}