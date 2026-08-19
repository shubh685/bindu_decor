import 'dart:ui';
import 'package:flutter/material.dart';

// Color Palette Theme inspired by home_page.dart
class LuxuryTheme {
  static const Color primaryDark = Color(0xFF0F2C23); // Dark Emerald Green
  static const Color primaryAccent = Color(0xFFD4AF37); // Signature Gold
  static const Color secondaryAccent = Color(0xFFC5A059); // Muted Gold Accent
  static const Color bgCream = Color(0xFFFBF9F5); // Elegant Warm Ivory
  static const Color textMuted = Color(0xFF55605C);
}

enum AuthMode { signIn, signUp, resetPassword }

enum ResetStep { enterEmail, enterOtp, newPassword }

class AdminAuth extends StatefulWidget {
  const AdminAuth({super.key});

  @override
  State<AdminAuth> createState() => _AdminAuthState();
}

class _AdminAuthState extends State<AdminAuth> {
  final _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.signUp;
  ResetStep _resetStep = ResetStep.enterEmail;

  bool _agreeTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
      _resetStep = ResetStep.enterEmail;
      _formKey.currentState?.reset();
    });
  }

  void _handleFormSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_authMode == AuthMode.resetPassword) {
        if (_resetStep == ResetStep.enterEmail) {
          setState(() {
            _resetStep = ResetStep.enterOtp;
          });
        } else if (_resetStep == ResetStep.enterOtp) {
          setState(() {
            _resetStep = ResetStep.newPassword;
          });
        } else if (_resetStep == ResetStep.newPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password successfully reset! Please sign in."),
              backgroundColor: LuxuryTheme.primaryDark,
            ),
          );
          _switchAuthMode(AuthMode.signIn);
        }
      } else if (_authMode == AuthMode.signUp) {
        if (!_agreeTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please agree to the Terms & Conditions."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: LuxuryTheme.primaryDark,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signed in successfully!"),
            backgroundColor: LuxuryTheme.primaryDark,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= 900;

    return Scaffold(
      backgroundColor: LuxuryTheme.bgCream,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              LuxuryTheme.primaryDark,
              Color(0xFF14372E),
              Color(0xFF0A201A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Decorative Spheres
            Positioned(
              top: -60,
              left: -60,
              child: _buildGlowSphere(220, LuxuryTheme.primaryAccent),
            ),
            Positioned(
              bottom: -80,
              right: -50,
              child: _buildGlowSphere(280, LuxuryTheme.secondaryAccent),
            ),

            // Main Centered Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glassmorphism Main Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: isDesktop ? 850 : 450,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: LuxuryTheme.primaryAccent.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(isDesktop ? 40 : 24),
                          child: Form(
                            key: _formKey,
                            child: isDesktop
                                ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 6, child: _buildFormSection()),
                                const SizedBox(width: 40),
                                Expanded(flex: 5, child: _buildSidePanelSection()),
                              ],
                            )
                                : Column(
                              children: [
                                _buildFormSection(),
                                const SizedBox(height: 32),
                                _buildSidePanelSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowSphere(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 90,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  // Left Side Dynamic Form Section
  Widget _buildFormSection() {
    String title;
    String buttonText;

    switch (_authMode) {
      case AuthMode.signUp:
        title = "Join the\nFuture";
        buttonText = "Sign Up";
        break;
      case AuthMode.signIn:
        title = "Welcome\nBack";
        buttonText = "Sign In";
        break;
      case AuthMode.resetPassword:
        if (_resetStep == ResetStep.enterEmail) {
          title = "Reset\nPassword";
          buttonText = "Verify Email";
        } else if (_resetStep == ResetStep.enterOtp) {
          title = "Verify\nOTP";
          buttonText = "Verify OTP";
        } else {
          title = "New\nPassword";
          buttonText = "Update Password";
        }
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1, letterSpacing: 0.5)),
        const SizedBox(height: 8),

        // Accent Line
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [LuxuryTheme.primaryAccent, LuxuryTheme.secondaryAccent],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Sign Up Fields
        if (_authMode == AuthMode.signUp) ...[
          _buildTextField(
            controller: _nameController,
            label: "Full Name",
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Please enter your name";
              return null;
            },
          ),
          const SizedBox(height: 18),
        ],

        // Email Field (Shown during Sign Up, Sign In, or Step 1 of Reset Password)
        if (_authMode != AuthMode.resetPassword || _resetStep == ResetStep.enterEmail) ...[
          _buildTextField(
            controller: _emailController,
            label: "Email Address",
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Please enter your email";
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                return "Please enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
        ],

        // Password Field (For Sign Up & Sign In)
        if (_authMode != AuthMode.resetPassword) ...[
          _buildTextField(
            controller: _passwordController,
            label: "Password",
            isPassword: true,
            validator: (val) {
              if (val == null || val.isEmpty) return "Please enter your password";
              if (val.length < 6) return "Password must be at least 6 characters";
              return null;
            },
          ),
          const SizedBox(height: 18),
        ],

        // Reset Password Step 2: OTP Entry
        if (_authMode == AuthMode.resetPassword && _resetStep == ResetStep.enterOtp) ...[
          _buildTextField(
            controller: _otpController,
            label: "Enter 6-Digit OTP",
            validator: (val) {
              if (val == null || val.trim().length != 6) {
                return "Please enter a valid 6-digit OTP";
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
        ],

        // Reset Password Step 3: New Password & Confirm Password
        if (_authMode == AuthMode.resetPassword && _resetStep == ResetStep.newPassword) ...[
          _buildTextField(
            controller: _newPasswordController,
            label: "New Password",
            isPassword: true,
            validator: (val) {
              if (val == null || val.isEmpty) return "Please enter new password";
              if (val.length < 6) return "Password must be at least 6 characters";
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: _confirmPasswordController,
            label: "Retype New Password",
            isPassword: true,
            validator: (val) {
              if (val == null || val.isEmpty) return "Please retype your password";
              if (val != _newPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
        ],

        // Options Footer
        if (_authMode == AuthMode.signUp)
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _agreeTerms,
                  activeColor: LuxuryTheme.primaryAccent,
                  checkColor: LuxuryTheme.primaryDark,
                  side: BorderSide(color: Colors.white.withOpacity(0.6)),
                  onChanged: (val) {
                    setState(() {
                      _agreeTerms = val ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "I agree to the Terms & Conditions",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          )
        else if (_authMode == AuthMode.signIn)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _switchAuthMode(AuthMode.resetPassword),
              child: const Text("Forgot Password?", style: TextStyle(color: LuxuryTheme.primaryAccent, fontSize: 13),),
            ),
          ),

        const SizedBox(height: 24),

        // Action Button
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [LuxuryTheme.primaryAccent, LuxuryTheme.secondaryAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: LuxuryTheme.primaryAccent.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _handleFormSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: LuxuryTheme.primaryDark, letterSpacing: 1.0)),
          ),
        ),
        const SizedBox(height: 20),

        // Mode Switchers
        Center(
          child: GestureDetector(
            onTap: () {
              if (_authMode == AuthMode.signUp) {
                _switchAuthMode(AuthMode.signIn);
              } else {
                _switchAuthMode(AuthMode.signUp);
              }
            },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.white70),
                children: [
                  TextSpan(
                    text: _authMode == AuthMode.signUp
                        ? "Already have an account? "
                        : "Don't have an account? ",
                  ),
                  TextSpan(
                    text: _authMode == AuthMode.signUp ? "Sign In" : "Sign Up",
                    style: const TextStyle(
                      color: LuxuryTheme.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Right Side Information Panel
  Widget _buildSidePanelSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Mode Switcher Toggle Pill
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LuxuryTheme.primaryAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _authMode == AuthMode.signUp ? "Welcome back" : "New here?",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _switchAuthMode(
                      _authMode == AuthMode.signUp ? AuthMode.signIn : AuthMode.signUp,
                    );
                  },
                  child: Image.asset(
                    "assets/images/bindu.png",
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.lock, color: LuxuryTheme.primaryAccent, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Glass Quote Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "“ The spaces have been waiting in silence. One thoughtful detail, and suddenly the whole room remembers how to feel like home. ”",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Image.asset(
                    "assets/images/bindu.png",
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                  const SizedBox(width: 8),
                  const Text("Bindu Décor Admin Portal", style: TextStyle(color: LuxuryTheme.primaryAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Security Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: LuxuryTheme.primaryAccent.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/bindu.png",
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.security, color: LuxuryTheme.primaryAccent, size: 16),
              ),
              const SizedBox(width: 8),
              const Text("Secure & Encrypted", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // Custom Form TextField Builder with Form Field Validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500,)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: LuxuryTheme.primaryAccent,
          validator: validator,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: LuxuryTheme.primaryAccent, width: 2),
            ),
            errorStyle: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 1),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}