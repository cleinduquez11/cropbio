import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: layout.isMobile ? 58 : 92,
        horizontal: layout.isMobile ? 14 : 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF111C14),
            Color(0xFF162216),
            Color(0xFF0F1712),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.isMobile ? layout.contentWidth : 920,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -44,
                right: -40,
                child: _glowCircle(
                  size: layout.isMobile ? 120 : 190,
                  color: primaryGreen.withOpacity(0.20),
                ),
              ),
              Positioned(
                bottom: -44,
                left: -35,
                child: _glowCircle(
                  size: layout.isMobile ? 110 : 165,
                  color: goldAccent.withOpacity(0.12),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(layout.isMobile ? 22 : 38),
                decoration: BoxDecoration(
                  color: darkSurface.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(
                    layout.isMobile ? 24 : 32,
                  ),
                  border: Border.all(
                    color: darkBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 34,
                      offset: const Offset(0, 18),
                      color: Colors.black.withOpacity(0.34),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _ctaBadge(),
                    const SizedBox(height: 18),
                    Text(
                      "Join the Future of Crop Biodiversity",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: layout.isMobile ? 28 : 42,
                        fontWeight: FontWeight.w900,
                        color: lightText,
                        height: 1.12,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Text(
                        "Subscribe to receive updates on CropBio research activities, field data releases, publications, biodiversity initiatives, and agricultural innovation.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: layout.isMobile ? 14.5 : 17,
                          height: 1.65,
                          color: mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const _SignupForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ctaBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mark_email_unread_rounded,
            color: goldAccent,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            "Stay connected with CropBio",
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

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _emailController = TextEditingController();

  bool isButtonHovered = false;
  bool isSubmitted = false;
  String? errorText;

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();

    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    );

    if (email.isEmpty) {
      setState(() {
        errorText = "Please enter your email address.";
      });
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        errorText = "Please enter a valid email address.";
      });
      return;
    }

    setState(() {
      errorText = null;
      isSubmitted = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isSubmitted = false;
        _emailController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          child: isSubmitted
              ? _successMessage()
              : layout.isMobile
                  ? _mobileForm()
                  : _desktopForm(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            errorText!,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.redAccent,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 22),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, "/contact");
          },
          icon: const Icon(
            Icons.mail_outline_rounded,
            color: mutedText,
            size: 19,
          ),
          label: Text(
            "Or Email Us Directly",
            style: GoogleFonts.nunito(
              fontSize: 15,
              height: 1.6,
              color: mutedText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _desktopForm() {
    return Row(
      key: const ValueKey("desktop-form"),
      children: [
        Expanded(
          child: _emailField(),
        ),
        const SizedBox(width: 14),
        _subscribeButton(),
      ],
    );
  }

  Widget _mobileForm() {
    return Column(
      key: const ValueKey("mobile-form"),
      children: [
        _emailField(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _subscribeButton(),
        ),
      ],
    );
  }

  Widget _emailField() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: errorText == null ? darkBorder : Colors.redAccent,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: _emailController,
        style: GoogleFonts.nunito(
          color: lightText,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: goldAccent,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: "Enter your email address",
          hintStyle: GoogleFonts.nunito(
            color: mutedText,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(
            Icons.email_rounded,
            color: mutedText,
            size: 21,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _subscribeButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isButtonHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isButtonHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          isButtonHovered ? -4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            if (isButtonHovered)
              BoxShadow(
                blurRadius: 22,
                offset: const Offset(0, 10),
                color: goldAccent.withOpacity(0.24),
              ),
          ],
        ),
        child: SizedBox(
          height: 58,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonHovered ? goldAccent : primaryGreen,
              foregroundColor: isButtonHovered ? Colors.black : lightText,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isButtonHovered ? goldAccent : darkBorder,
                ),
              ),
            ),
            onPressed: _submit,
            icon: Icon(
              Icons.send_rounded,
              color: isButtonHovered ? Colors.black : lightText,
              size: 18,
            ),
            label: Text(
              "Subscribe",
              style: GoogleFonts.nunito(
                color: isButtonHovered ? Colors.black : lightText,
                fontWeight: FontWeight.w900,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _successMessage() {
    return Container(
      key: const ValueKey("success-message"),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: darkSurface3,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: goldAccent.withOpacity(0.55),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: goldAccent,
            size: 22,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "Thank you for subscribing!",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}