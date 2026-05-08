

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 100,
        horizontal: 20,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F4F2F),
            Color(0xFF1E2E1E),
          ],
        ),
      ),

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 850,
          ),

          child: Column(
            children: [

              const Text(
                "Join the Future of Crop Biodiversity",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Subscribe to receive updates on research, publications, biodiversity initiatives, and agricultural innovations.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 50),

              const _SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}


class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  bool _hover = false;
  bool _submitted = false;

  void _submit() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _submitted = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _submitted = false;
          _emailController.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _submitted
              ? const Text(
                  "Thank you for subscribing!",
                  key: ValueKey("success"),
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Row(
                  key: const ValueKey("form"),
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Enter your email address",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    MouseRegion(
                      onEnter: (_) => setState(() => _hover = true),
                      onExit: (_) => setState(() => _hover = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        transform: _hover
                            ? (Matrix4.identity()..translate(0, -5))
                            : Matrix4.identity(),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC6A432),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            "Subscribe",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 25),
        TextButton(
            onPressed: () {
              // You can link to contact page here
            },
            child: Text(
              "Or Email Us Directly",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                height: 1.6,
                color: Colors.white70,
              ),
            )),
      ],
    );
  }
}


