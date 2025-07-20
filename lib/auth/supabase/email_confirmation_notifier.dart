import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailConfirmationNotifier extends StateNotifier<EmailConfirmationState> {
  EmailConfirmationNotifier() : super(EmailConfirmationState());

  Timer? _timer;

  void startCooldown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft == 0) {
        state = state.copyWith(canResend: true);
        _timer?.cancel();
      } else {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      }
    });
  }

  void resendEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Confirmation email sent')),
    );

    state = state.copyWith(canResend: false, secondsLeft: 60);

    startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}

final emailConfirmationProvider = StateNotifierProvider<EmailConfirmationNotifier, EmailConfirmationState>((ref) => EmailConfirmationNotifier());

class EmailConfirmationState {
  final bool canResend;
  final int secondsLeft;

  const EmailConfirmationState({
    this.canResend = false,
    this.secondsLeft = 60,
  });

  EmailConfirmationState copyWith({
    bool? canResend,
    int? secondsLeft,
  }) {
    return EmailConfirmationState(
      canResend: canResend ?? this.canResend,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }

}