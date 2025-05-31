import 'package:equatable/equatable.dart';

abstract class PhoneAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends PhoneAuthEvent {
  final String phoneNumber;

  PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SubmitPhoneNumber extends PhoneAuthEvent {}
