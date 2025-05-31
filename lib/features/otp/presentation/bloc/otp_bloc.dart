import 'dart:async';

import 'package:chat/features/auth/data/remote_data_source/auth_api.dart';
import 'package:chat/features/otp/data/otp_remote_data_source/otp_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpApi otpApi;
  final AuthApi authApi;
  Timer? _timer;
  int _resendSecondsLeft = 30;
  OtpBloc({required this.otpApi, required this.authApi})
      : super(OtpState.initial()) {
    on<OtpDigitChanged>(_onOtpDigitChanged);
    on<SubmitOtp>(_onSubmitOtp);
    on<ResendOtp>(_onResendOtp);
    on<DecrementResendTimer>(_onDecrementResendTimer);
    on<ResendTimerTick>(_onResendTimerTick);

    _startResendTimer();
  }

  void _onOtpDigitChanged(OtpDigitChanged event, Emitter<OtpState> emit) {
    final updatedOtp = event.value;
    emit(state.copyWith(
      otpDigits: updatedOtp,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitOtp(SubmitOtp event, Emitter<OtpState> emit) async {
    final otpCode = state.otpDigits;

    if (otpCode.trim().length != 4) {
      emit(state.copyWith(
        status: OtpStatus.failure,
        errorMessage: 'لطفا کد ۴ رقمی را به درستی وارد کنید',
      ));
      return;
    }

    emit(state.copyWith(status: OtpStatus.submitting, errorMessage: null));
    try {
      final token = await otpApi.verifyOtp(
          phone: "0${event.phone}", otp: int.parse(state.otpDigits));
      emit(state.copyWith(status: OtpStatus.success, token: token));
    } catch (e) {
      emit(
        state.copyWith(
          status: OtpStatus.failure,
          errorMessage: e.toString().replaceAll('Exception:', ''),
        ),
      );
      return;
    }
  }

  Future<void> _onResendOtp(ResendOtp event, Emitter<OtpState> emit) async {
    if (state.resendSecondsLeft > 0) {
      return;
    }

    emit(state.copyWith(
        status: OtpStatus.submitting, errorMessage: null, otpDigits: ""));

    try {
      try {
        await authApi.sendOtp("0${event.phone}");

        emit(state.copyWith(status: OtpStatus.success));
      } catch (e) {
        emit(state.copyWith(
          status: OtpStatus.failure,
          errorMessage: e.toString().replaceAll('Exception:', ''),
        ));
      }

      emit(state.copyWith(
          status: OtpStatus.initial,
          errorMessage: null,
          resendSecondsLeft: 30));
      _startResendTimer();
    } catch (_) {
      emit(state.copyWith(
          status: OtpStatus.failure,
          errorMessage: 'خطا در ارسال مجدد کد، لطفا دوباره تلاش کنید'));
    }
  }

  void _onDecrementResendTimer(
      DecrementResendTimer event, Emitter<OtpState> emit) {
    if (_resendSecondsLeft > 0) {
      _resendSecondsLeft -= 1;
      emit(state.copyWith(resendSecondsLeft: _resendSecondsLeft));
    } else {
      _timer?.cancel();
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendSecondsLeft = 30;
    add(ResendTimerTick());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(ResendTimerTick());
      if (_resendSecondsLeft <= 0) {
        _timer?.cancel();
      }
    });
  }

  void _onResendTimerTick(ResendTimerTick event, Emitter<OtpState> emit) {
    if (_resendSecondsLeft > 0) {
      _resendSecondsLeft--;
      emit(state.copyWith(resendSecondsLeft: _resendSecondsLeft));
    } else {
      _timer?.cancel();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
