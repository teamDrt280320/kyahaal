import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kyahaal/controllers/auth.dart';
import 'package:kyahaal/utils/constants.dart';
import 'package:kyahaal/widgets/input_field.dart';
import 'package:kyahaal/widgets/parent_widget.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 25);
    return ParentWidget.white(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      footer: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => PrimaryButton.loader(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _authController.isOtpSent
                        ? _authController.verifyOtp()
                        : _authController.sendOtp();
                  }
                },
                text: _authController.isOtpSent ? 'Verify OTP' : 'Send OTP',
                showLoader: _authController.authProcessing.value,
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Obx(
              () => Column(
                children: [
                  const Spacer(),
                  InputField(
                    onSubmit: (_) {
                      if (_formKey.currentState?.validate() ?? false) {
                        _authController.sendOtp();
                      }
                    },
                    validator: (phone) {
                      return (phone != null && phone.length == 10)
                          ? null
                          : 'Please enter a valid phone';
                    },
                    controller: _authController.phoneController,
                    textInputAction: _authController.isOtpSent
                        ? TextInputAction.next
                        : TextInputAction.done,
                    label: 'Phone Number',
                    prefixText: '+91',
                    keyboardType: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumberDevice],
                    maxLength: 10,
                  ),
                  if (_authController.isOtpSent) ...[
                    sizedBox,
                    InputField(
                      validator: (otp) {
                        return (otp != null &&
                                otp.isNotEmpty &&
                                otp.length == 6)
                            ? null
                            : 'Enter a valid OTP';
                      },
                      controller: _authController.otpController,
                      textInputAction: TextInputAction.next,
                      label: 'OTP',
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      maxLength: 6,
                    ),
                    sizedBox,
                    InputField(
                      validator: (uname) {
                        return (uname != null &&
                                uname.isNotEmpty &&
                                uname.length > 6)
                            ? null
                            : 'UserName Should be of more than 6 characters';
                      },
                      controller: _authController.displayNameController,
                      textInputAction: TextInputAction.done,
                      label: 'UserName',
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.name],
                      onSubmit: (_) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _authController.verifyOtp();
                        }
                      },
                    ),
                  ],
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bgColor = brandBlack,
    this.fgColor = Colors.white,
    this.size = const Size(140, 50),
  })  : showLoader = false,
        super(key: key);

  const PrimaryButton.loader({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bgColor = brandBlack,
    this.fgColor = Colors.white,
    this.size = const Size(140, 50),
    this.showLoader = false,
  }) : super(key: key);

  final GestureTapCallback onPressed;
  final String text;
  final Color bgColor, fgColor;
  final Size size;
  final bool showLoader;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          foregroundColor: MaterialStateProperty.all(fgColor),
        ),
        onPressed: onPressed,
        child: showLoader
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(fgColor))
            : Text(text),
      ),
    );
  }
}
