import 'package:chat/features/auth/data/remote_data_source/auth_api.dart';
import 'package:chat/features/chat/presentation/contacts_page.dart';
import 'package:chat/features/otp/data/otp_remote_data_source/otp_api.dart';
import 'package:chat/utils/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../bloc/otp_bloc.dart';

class OtpPage extends StatelessWidget {
  final String phone;

  const OtpPage({required this.phone, super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => OtpBloc(otpApi: OtpApi(), authApi: AuthApi()),
      child: AppBackground(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: BackButton(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black87,
            ),
            body: BlocConsumer<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state.status == OtpStatus.success && state.token != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ContactsPage(
                              userToken: state.token!,
                            )),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'هپی چت',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.05),
                      const Text(
                        '.برای ثبت‌نام کد ۴ رقمی ارسال شده را وارد نمایید',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      PinCodeTextField(
                        appContext: context,
                        length: 4,
                        animationType: AnimationType.scale,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 55,
                          fieldWidth: 55,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: state.status == OtpStatus.failure
                              ? Colors.red
                              : Colors.black,
                          inactiveColor: state.status == OtpStatus.failure
                              ? Colors.red
                              : Colors.grey,
                          selectedColor: state.status == OtpStatus.failure
                              ? Colors.red
                              : Colors.blue,
                          borderWidth: 2,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        autoDismissKeyboard: true,
                        onChanged: (value) {
                          context.read<OtpBloc>().add(OtpDigitChanged(value));
                        },
                        onCompleted: (value) {
                          if (value.length == 4) {
                            context.read<OtpBloc>().add(SubmitOtp(phone));
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      if (state.errorMessage != null)
                        Column(
                          children: [
                            Text(
                              state.errorMessage!
                                      .toLowerCase()
                                      .contains('invalid otp')
                                  ? 'کد وارد شده معتبر نمی‌باشد'
                                  : state.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      if (state.status == OtpStatus.submitting)
                        Column(
                          children: [
                            const CircularProgressIndicator(color: Colors.red),
                            const SizedBox(height: 10),
                          ],
                        ),
                      if (state.resendSecondsLeft > 0)
                        Text(
                          'ارسال مجدد کد تا ${state.resendSecondsLeft} ثانیه دیگر',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            context.read<OtpBloc>().add(ResendOtp(phone));
                          },
                          child: const Text('ارسال مجدد کد'),
                        ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
