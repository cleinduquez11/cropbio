import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Providers/LayoutProvider.dart';

class EmailVerificationPage extends StatefulWidget {

  final String email;

  const EmailVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState
    extends State<EmailVerificationPage> {

  bool _isResending = false;

  Future<void> _resendEmail() async {

    setState(() {
      _isResending = true;
    });

    /// TODO: call resend API
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      _isResending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Verification email resent",
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
        body: Center(
          child: CircularProgressIndicator(),
        ),
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
                        email: widget.email,
                        onResend: _resendEmail,
                        isResending: _isResending,
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: _LeftPanel(),
                    ),

                    const SizedBox(width: 60),

                    Expanded(
                      child: _RightPanel(
                        email: widget.email,
                        onResend: _resendEmail,
                        isResending: _isResending,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LEFT PANEL (Same Style as Signup)
////////////////////////////////////////////////////////////

class _LeftPanel extends StatelessWidget {

  const _LeftPanel();

  @override
  Widget build(BuildContext context) {

    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [

        Container(
          height:
              layout.isMobile ? 180 : 320,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20),
            color:
                Colors.green.withOpacity(0.08),
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
          "Verify Your Email",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                layout.titleFontSize + 6,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          "To continue using CropBio, please verify your email address.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                layout.bodyFontSize,
            height: 1.6,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// RIGHT PANEL
////////////////////////////////////////////////////////////

class _RightPanel extends StatelessWidget {

  final String email;
  final VoidCallback onResend;
  final bool isResending;

  const _RightPanel({
    required this.email,
    required this.onResend,
    required this.isResending,
  });

  @override
  Widget build(BuildContext context) {

    final layout = context.watch<LayoutProvider>();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [

        Icon(
          Icons.mark_email_unread_rounded,
          size: layout.isMobile ? 70 : 90,
          color: const Color(0xFF3F6B2A),
        ),

        const SizedBox(height: 25),

        Text(
          "A verification link has been sent to:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                layout.bodyFontSize,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                layout.bodyFontSize + 2,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3F6B2A),
          ),
        ),

        const SizedBox(height: 25),

        Text(
          "Please check your inbox and click the verification link to activate your account.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                layout.bodyFontSize,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 35),

        ElevatedButton(
          onPressed:
              isResending ? null : onResend,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF3F6B2A),
            padding:
                const EdgeInsets.symmetric(
              vertical: 16,
            ),
          ),
          child: isResending
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  "Resend Email",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),

        const SizedBox(height: 15),

        TextButton(
          onPressed: () {

            Navigator.pushReplacementNamed(
              context,
              "/signin",
            );

          },
          child: Text(
            "Back to Login",
            style: TextStyle(
              fontSize:
                  layout.bodyFontSize,
            ),
          ),
        ),
      ],
    );
  }
}