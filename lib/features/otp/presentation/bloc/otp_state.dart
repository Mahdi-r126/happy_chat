part of 'otp_bloc.dart';

enum OtpStatus { initial, submitting, success, failure }

class OtpState {
  final String otpDigits;
  final OtpStatus status;
  final String? errorMessage;
  final String? token;
  final int resendSecondsLeft;

  const OtpState(
      {required this.otpDigits,
      this.status = OtpStatus.initial,
      this.errorMessage,
      this.token,
      this.resendSecondsLeft = 0});

  factory OtpState.initial() =>
      OtpState(otpDigits: "", status: OtpStatus.initial, resendSecondsLeft: 30);

  OtpState copyWith({
    String? otpDigits,
    OtpStatus? status,
    String? errorMessage,
    String? token,
    int? resendSecondsLeft,
  }) {
    return OtpState(
      otpDigits: otpDigits ?? this.otpDigits,
      status: status ?? this.status,
      errorMessage: errorMessage,
      token: token,
      resendSecondsLeft: resendSecondsLeft ?? this.resendSecondsLeft,
    );
  }
}
