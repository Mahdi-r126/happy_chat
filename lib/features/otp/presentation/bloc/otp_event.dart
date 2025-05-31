part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpDigitChanged extends OtpEvent {
  final String value;

  const OtpDigitChanged(this.value);
}

class SubmitOtp extends OtpEvent {
  final String phone;

  const SubmitOtp(this.phone);

  @override
  List<Object> get props => [phone];
}

class ResendOtp extends OtpEvent {
  final String phone;

  const ResendOtp(this.phone);
}

class DecrementResendTimer extends OtpEvent {}

class ResendTimerTick extends OtpEvent {}
