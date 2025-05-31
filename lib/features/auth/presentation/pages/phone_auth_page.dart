import 'package:chat/features/otp/presentation/pages/otp_page.dart';
import 'package:chat/utils/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/phone_auth_bloc.dart';
import '../bloc/phone_auth_event.dart';
import '../bloc/phone_auth_state.dart';

class PhoneAuthPage extends StatelessWidget {
  const PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhoneAuthBloc(),
      child: AppBackground(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: const Padding(
            padding: EdgeInsets.all(20),
            child: _PhoneAuthView(),
          ),
        ),
      ),
    );
  }
}

class _PhoneAuthView extends StatefulWidget {
  const _PhoneAuthView();

  @override
  State<_PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<_PhoneAuthView> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
      builder: (context, state) {
        if (_phoneController.text != state.phoneNumber) {
          _phoneController.text = state.phoneNumber;
          _phoneController.selection = TextSelection.fromPosition(
              TextPosition(offset: _phoneController.text.length));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height * 0.15),
            const Text(
              'هپی چت',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.05),
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 12, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.phoneNumberError != null
                      ? Colors.red.shade400
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/iran_flag.png',
                    width: 32,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '+98',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'شماره تلفن خود را وارد نمایید',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                      ),
                      onChanged: (value) {
                        context
                            .read<PhoneAuthBloc>()
                            .add(PhoneNumberChanged(value));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              state.phoneNumberError ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 13,
              ),
            ),
            SizedBox(height: height * 0.2),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.phoneNumber.isNotEmpty &&
                        state.status != PhoneAuthStatus.submitting
                    ? () {
                        context.read<PhoneAuthBloc>().add(SubmitPhoneNumber());
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return OtpPage(
                              phone: state.phoneNumber,
                            );
                          },
                        ));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      state.phoneNumber.isNotEmpty ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: state.status == PhoneAuthStatus.submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'ثبت‌نام',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
