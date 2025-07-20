import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:workout_tracker/auth/supabase/email_confirmation_notifier.dart';
import 'package:workout_tracker/style/global_colors.dart';
import 'package:workout_tracker/views/pages/auth/auth_page.dart';

class EmailConfirmationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  ConsumerState<EmailConfirmationScreen> createState() => _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends ConsumerState<EmailConfirmationScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(emailConfirmationProvider.notifier).startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final confirmationNotifier = ref.watch(emailConfirmationProvider.notifier);
    final confirmationState = ref.watch(emailConfirmationProvider);

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  LottieBuilder.asset('assets/lottie/email.json', repeat: true),
                  const SizedBox(height: 10),
                  Text(
                    'Email Confirmation',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      children: [
                        const TextSpan(text: 'We have sent email to '),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(color: Colors.blue),
                        ),
                        const TextSpan(
                          text: ' to confirm the validity of our email address. After receiving the email, follow the link provided to complete your registration.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Resending email...')),
                      // );
                      confirmationNotifier.resendEmail(context);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Resend email in ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: '${confirmationState.secondsLeft} secs',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   _isLoading = true;
                      // });
                      // SupabaseAuth.instance.getUser();
                      // if (SupabaseAuth.instance.isEmailConfirmed == true) {
                      //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const AuthPage()));
                      //   Alerts.showFlushBar(context, 'Email confirmed successfully!', false);
                      // }
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AuthPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
