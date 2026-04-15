import 'package:cropbio/API/AuthServices.dart';
import 'package:cropbio/Models/UserModel.dart';
import 'package:cropbio/Providers/UserSession.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      /// Start loading
      setState(() {
        _isLoading = true;
      });

      print("${_emailController.text} "
          "${_passwordController.text}");

      /// Call API
      final AppUser? user = await AuthService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      /// 🔥 SAFETY CHECK
      if (!mounted) return;

      /// Stop loading
      setState(() {
        _isLoading = false;
      });

      /// =========================
      /// LOGIN SUCCESS
      /// =========================

      if (user != null) {
        /// SAVE USER SESSION
        await UserSession.saveUser(user);

        CustomSnackBar.show(
          context,
          message: "Login successful",
          backgroundColor: Colors.green,
          icon: Icons.check,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );

        /// Navigate to dashboard
        Navigator.pushReplacementNamed(
          context,
          "/landingpage",
        );
      }

      /// =========================
      /// LOGIN FAILED
      /// =========================

      else {
        CustomSnackBar.show(
          context,
          message: "Invalid email/password or email not verified",
          backgroundColor: Colors.orange,
          icon: Icons.warning,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Ensure layout is initialized after refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LayoutProvider>().update(
            BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            context,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();
    final isReady = layout.screenWidth > 0;

    if (!isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: layout.outerMargin,
                vertical: layout.verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ================= LOGO =================
                  Container(
                    height: layout.isMobile ? 90 : 120,
                    width: layout.isMobile ? 90 : 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SvgPicture.asset(
                      "lib/Assets/Cropbio_Logo_Dark.svg",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: layout.titleFontSize + 6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Sign in to CropBio",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: layout.bodyFontSize,
                      color: Colors.grey,
                    ),
                  ),

                  const Divider(),

                  const SizedBox(height: 20),

                  /// ================= FORM =================
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// EMAIL
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }

                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );

                            if (!emailRegex.hasMatch(value)) {
                              return "Enter a valid email";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        /// PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onFieldSubmitted: (_) =>
                              _submit(), // ✅ ENTER KEY HERE
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }

                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// ================= FORGOT PASSWORD =================
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot-password");
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ================= SIGN IN BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F6B2A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _submit,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: layout.bodyFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text("or"),
                  const SizedBox(height: 20),

                  /// ================= SOCIAL LOGIN =================
                  _SocialButton(
                    label: "Continue with Google",
                    icon: Icons.g_mobiledata,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 10),

                  _SocialButton(
                    label: "Continue with Apple",
                    icon: Icons.apple,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 10),

                  _SocialButton(
                    label: "Continue with Email",
                    icon: Icons.email_outlined,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 20),

                  /// ================= SIGN UP LINK =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: layout.bodyFontSize),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text("Sign Up"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= SOCIAL BUTTON =================
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return SizedBox(
      width: layout.contentWidth,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: layout.iconSize),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
