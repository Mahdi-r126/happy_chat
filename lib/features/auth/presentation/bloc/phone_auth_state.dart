import 'package:equatable/equatable.dart';

enum PhoneAuthStatus { initial, submitting, success, failure }

class PhoneAuthState extends Equatable {
  final String phoneNumber;
  final bool isPhoneNumberValid;
  final String? phoneNumberError;
  final PhoneAuthStatus status;

  const PhoneAuthState({
    this.phoneNumber = '',
    this.isPhoneNumberValid = false,
    this.phoneNumberError,
    this.status = PhoneAuthStatus.initial,
  });

  PhoneAuthState copyWith({
    String? phoneNumber,
    bool? isPhoneNumberValid,
    String? phoneNumberError,
    PhoneAuthStatus? status,
  }) {
    return PhoneAuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      phoneNumberError: phoneNumberError,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [phoneNumber, status, phoneNumberError, isPhoneNumberValid];
}
