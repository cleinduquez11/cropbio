import 'package:cropbio/API/AuthServices.dart';
import 'package:cropbio/Models/UserModel.dart';
import 'package:cropbio/Widgets/EmailConfirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../Providers/LayoutProvider.dart';
import 'Widgets/CustomSnackbar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _agencyController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newUser = AppUser(
        fullName: _nameController.text,
        agency: _agencyController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      print(newUser.toJson());

      final success = await AuthService.signUp(newUser);

      /// 🔥 SAFETY CHECK
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        CustomSnackBar.show(
          context,
          message: "Account created successfully",
          backgroundColor: Colors.green, // optional
          icon: Icons.check, // optional
          bottomMargin: 40, // optional
          leftMarginFactor: 0.8, // optional (0.0 left, 0.5 center, 0.8 right)
        );

        Future.delayed(Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationPage(
              email: _emailController.text,
            ),
          ),
        );

        /// Optional navigation
        // Navigator.pushNamed(context, "/signin");
      } else {
        CustomSnackBar.show(
          context,
          message: "Signup failed. Try again.",
          backgroundColor: Colors.orange, // optional
          icon: Icons.warning, // optional
          bottomMargin: 40, // optional
          leftMarginFactor: 0.8, // optional (0.0 left, 0.5 center, 0.8 right)
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _agencyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        child: Container(
          width: layout.contentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: layout.outerMargin,
            vertical: layout.verticalPadding,
          ),
          child: layout.isMobile
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      const _LeftPanel(),
                      const SizedBox(height: 30),
                      _RightPanel(
                        formKey: _formKey,
                        nameController: _nameController,
                        agencyController: _agencyController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onSubmit: _submit,
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: _LeftPanel()),
                    const SizedBox(width: 60),
                    Expanded(
                      child: _RightPanel(
                        formKey: _formKey,
                        nameController: _nameController,
                        agencyController: _agencyController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onSubmit: _submit,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: layout.isMobile ? 180 : 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.withOpacity(0.08),
          ),
          child: Center(
            child: SvgPicture.asset(
              "lib/Assets/Cropbio_Logo_Dark.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Join CropBio",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: layout.titleFontSize + 6,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Be part of a national effort to preserve crop biodiversity, support research, and promote sustainable agriculture.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: layout.bodyFontSize,
            height: 1.6,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController agencyController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  const _RightPanel({
    required this.formKey,
    required this.nameController,
    required this.agencyController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: layout.titleFontSize + 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _AuthTextField(
              label: "Full Name",
              controller: nameController,
              onSubmitted: onSubmit,
              validator: (v) => v!.isEmpty ? "Full name is required" : null,
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              label: "Agency/Affiliation",
              controller: agencyController,
              onSubmitted: onSubmit,
              validator: (v) => v!.isEmpty ? "Agency is required" : null,
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              label: "Email",
              controller: emailController,
              onSubmitted: onSubmit,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!v.contains("@")) return "Invalid email";
                return null;
              },
            ),
            const SizedBox(height: 12),
            _AuthTextField(
              label: "Password",
              controller: passwordController,
              onSubmitted: onSubmit,
              obscure: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Password required";
                if (v.length < 6) return "Min 6 characters";
                return null;
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F6B2A),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: layout.iconSize),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onSubmitted; // 👈 ADD THIS

  const _AuthTextField({
    required this.label,
    required this.controller,
    this.obscure = false,
    this.validator,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      textInputAction: TextInputAction.done, // 👈 Enter behavior

      onFieldSubmitted: (_) {
        if (onSubmitted != null) {
          onSubmitted!(); // 👈 triggers submit
        }
      },

      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
