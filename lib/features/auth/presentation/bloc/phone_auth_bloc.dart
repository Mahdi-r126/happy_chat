import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/remote_data_source/auth_api.dart';
import 'phone_auth_event.dart';
import 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final AuthApi _authApi;
  bool _validatePhoneNumber(String phone) {
    final regExp = RegExp(r'^(09|9)\d{9}$');
    return regExp.hasMatch(phone);
  }

  PhoneAuthBloc({AuthApi? authApi})
      : _authApi = authApi ?? AuthApi(),
        super(const PhoneAuthState()) {
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<SubmitPhoneNumber>(_onSubmitPhoneNumber);
  }

  void _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<PhoneAuthState> emit) {
    final isValid = _validatePhoneNumber(event.phoneNumber);
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      isPhoneNumberValid: isValid,
      phoneNumberError: null,
      status: PhoneAuthStatus.initial,
    ));
  }

  Future<void> _onSubmitPhoneNumber(
      SubmitPhoneNumber event, Emitter<PhoneAuthState> emit) async {
    if (!state.isPhoneNumberValid) {
      emit(state.copyWith(
        status: PhoneAuthStatus.failure,
        phoneNumberError:
            '.به نظر می آید شماره تلفن معتبری وارد نکرده اید.مجددا تلاش کنید',
      ));
    } else {
      emit(state.copyWith(
        status: PhoneAuthStatus.submitting,
        phoneNumberError: null,
      ));
      try {
        await _authApi.sendOtp("0${state.phoneNumber}");

        emit(state.copyWith(status: PhoneAuthStatus.success));
      } catch (e) {
        emit(state.copyWith(
            status: PhoneAuthStatus.failure,
            phoneNumberError: e.toString().replaceAll('Exception:', ''),
            phoneNumber: ""));
      }
    }
  }
}
