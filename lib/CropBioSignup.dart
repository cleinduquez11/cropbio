import 'package:cropbio/API/AuthServices.dart';
import 'package:cropbio/Models/UserModel.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:cropbio/Widgets/EmailConfirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void dispose() {
    _nameController.dispose();
    _agencyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<LayoutProvider>().update(
            BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            context,
          );
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final newUser = AppUser(
      fullName: _nameController.text.trim(),
      agency: _agencyController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      final success = await AuthService.signUp(newUser);

      if (!mounted) return;

      if (success) {
        _showSnackBar(
          message: "Account created successfully",
          backgroundColor: primaryGreen,
          icon: Icons.check_circle_rounded,
        );

        await Future.delayed(const Duration(milliseconds: 700));

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationPage(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        _showSnackBar(
          message: "Signup failed. Please try again.",
          backgroundColor: Colors.orange,
          icon: Icons.warning_rounded,
        );
      }
    } catch (_) {
      if (!mounted) return;

      _showSnackBar(
        message: "Unable to create account. Please try again.",
        backgroundColor: Colors.redAccent,
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    CustomSnackBar.show(
      context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      bottomMargin: 40,
      leftMarginFactor: 0.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final isReady = layout.screenWidth > 0;

    if (!isReady) {
      return const Scaffold(
        backgroundColor: darkBg,
        body: Center(
          child: CircularProgressIndicator(
            color: goldAccent,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: darkBg,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F1712),
              Color(0xFF111C14),
              Color(0xFF162216),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: layout.isMobile ? 16 : 28,
                vertical: layout.isMobile ? 28 : 44,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: layout.isMobile
                    ? Column(
                        children: [
                          _brandPanel(layout),
                          const SizedBox(height: 20),
                          _formPanel(layout),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _brandPanel(layout),
                          ),
                          const SizedBox(width: 28),
                          Expanded(
                            flex: 4,
                            child: _formPanel(layout),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandPanel(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 24 : 38),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.88),
        borderRadius: BorderRadius.circular(layout.isMobile ? 26 : 34),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 34,
            offset: const Offset(0, 18),
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -54,
            right: -48,
            child: _glowCircle(
              size: layout.isMobile ? 130 : 220,
              color: primaryGreen.withOpacity(0.20),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -44,
            child: _glowCircle(
              size: layout.isMobile ? 120 : 190,
              color: goldAccent.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: layout.isMobile ? 94 : 126,
                width: layout.isMobile ? 150 : 190,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.25),
                  ),
                ),
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_clean.svg",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: layout.isMobile ? 24 : 40),
              _badge(),
              const SizedBox(height: 18),
              Text(
                "Join CropBio",
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontSize: layout.isMobile ? 30 : 44,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Create an account to access CropBio data tools, field records, research dashboards, and space-enabled crop biodiversity resources.",
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: layout.isMobile ? 14.5 : 16,
                  fontWeight: FontWeight.w600,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _FeatureChip(
                    icon: Icons.satellite_alt_rounded,
                    label: "Earth Observation",
                  ),
                  _FeatureChip(
                    icon: Icons.flight_takeoff_rounded,
                    label: "UAV Mapping",
                  ),
                  _FeatureChip(
                    icon: Icons.edit_location_alt_rounded,
                    label: "Field Data",
                  ),
                  _FeatureChip(
                    icon: Icons.eco_rounded,
                    label: "Crop Diversity",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formPanel(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 22 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(layout.isMobile ? 26 : 34),
        border: Border.all(
          color: Colors.white.withOpacity(0.70),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 34,
            offset: const Offset(0, 18),
            color: Colors.black.withOpacity(0.26),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: GoogleFonts.nunito(
                  color: darkBg,
                  fontSize: layout.isMobile ? 28 : 34,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Fill in your details to get started.",
                style: GoogleFonts.nunito(
                  color: const Color(0xFF60705A),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),

              _AuthTextField(
                controller: _nameController,
                label: "Full name",
                hintText: "Enter your full name",
                icon: Icons.person_rounded,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final name = value?.trim() ?? "";
                  if (name.isEmpty) return "Full name is required";
                  if (name.length < 3) return "Enter your complete name";
                  return null;
                },
              ),

              const SizedBox(height: 14),

              _AuthTextField(
                controller: _agencyController,
                label: "Agency / Affiliation",
                hintText: "Enter your agency or institution",
                icon: Icons.business_rounded,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final agency = value?.trim() ?? "";
                  if (agency.isEmpty) return "Agency or affiliation is required";
                  return null;
                },
              ),

              const SizedBox(height: 14),

              _AuthTextField(
                controller: _emailController,
                label: "Email address",
                hintText: "name@example.com",
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final email = value?.trim() ?? "";
                  if (email.isEmpty) return "Email is required";

                  final emailRegex = RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                  );

                  if (!emailRegex.hasMatch(email)) {
                    return "Enter a valid email address";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              _AuthTextField(
                controller: _passwordController,
                label: "Password",
                hintText: "Create a password",
                icon: Icons.lock_rounded,
                obscureText: _obscurePassword,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  tooltip:
                      _obscurePassword ? "Show password" : "Hide password",
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: primaryGreen,
                  ),
                ),
                validator: (value) {
                  final password = value ?? "";
                  if (password.isEmpty) return "Password is required";
                  if (password.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              _AuthTextField(
                controller: _confirmPasswordController,
                label: "Confirm password",
                hintText: "Re-enter your password",
                icon: Icons.verified_user_rounded,
                obscureText: _obscureConfirmPassword,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  tooltip: _obscureConfirmPassword
                      ? "Show password"
                      : "Hide password",
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: primaryGreen,
                  ),
                ),
                validator: (value) {
                  final confirmPassword = value ?? "";

                  if (confirmPassword.isEmpty) {
                    return "Please confirm your password";
                  }

                  if (confirmPassword != _passwordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              _SignUpButton(
                isLoading: _isLoading,
                onPressed: _submit,
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Already have an account?",
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF60705A),
                        fontSize: layout.bodyFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushNamed(context, "/signin");
                          },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.nunito(
                        color: primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.32),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_add_alt_1_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "CropBio Account Registration",
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final String? Function(String?) validator;
  final void Function(String)? onSubmitted;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
  });

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color lightSurface = Color(0xFFF7F9F4);
  static const Color lightBorder = Color(0xFFE1E8DA);
  static const Color darkText = Color(0xFF162216);
  static const Color mutedText = Color(0xFF60705A);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: GoogleFonts.nunito(
        color: darkText,
        fontWeight: FontWeight.w800,
      ),
      cursorColor: primaryGreen,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: primaryGreen,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: lightSurface,
        labelStyle: GoogleFonts.nunito(
          color: mutedText,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: GoogleFonts.nunito(
          color: mutedText.withOpacity(0.75),
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SignUpButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<_SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<_SignUpButton> {
  bool isHovered = false;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isLoading
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.isLoading) {
          setState(() {
            isHovered = true;
          });
        }
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isHovered ? -4 : 0,
          0,
        ),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, isHovered ? 12 : 6),
              color: primaryGreen.withOpacity(isHovered ? 0.25 : 0.12),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isHovered ? goldAccent : primaryGreen,
            disabledBackgroundColor: primaryGreen.withOpacity(0.55),
            foregroundColor: isHovered ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: widget.isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Create Account",
                  style: GoogleFonts.nunito(
                    color: isHovered ? Colors.black : Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: accentGreen,
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}