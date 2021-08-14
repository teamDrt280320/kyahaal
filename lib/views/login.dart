import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kyahaal/controllers/auth.dart';
import 'package:kyahaal/widgets/input_field.dart';
import 'package:kyahaal/widgets/parent_widget.dart';
import 'package:kyahaal/widgets/primary_button.dart';

class LoginScreen extends GetView<AuthController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const customSpacer = SizedBox(height: 25);
    return ParentWidget.white(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      footer: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => PrimaryButton.loader(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.isOtpSent
                        ? controller.verifyOtp()
                        : controller.sendOtp();
                  }
                },
                text: controller.isOtpSent ? 'Verify OTP' : 'Send OTP',
                showLoader: controller.authProcessing.value,
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
                    readOnly: controller.isOtpSent,
                    onSubmit: (_) {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.sendOtp();
                      }
                    },
                    validator: (phone) {
                      return (phone != null && phone.length == 10)
                          ? null
                          : 'Please enter a valid phone';
                    },
                    controller: controller.phoneController,
                    textInputAction: controller.isOtpSent
                        ? TextInputAction.next
                        : TextInputAction.done,
                    label: 'Phone Number',
                    prefixText: '+91 ',
                    keyboardType: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumberDevice],
                    maxLength: 10,
                    letterSpacing: 1.7,
                  ),
                  if (controller.isOtpSent) ...[
                    customSpacer,
                    InputField(
                      validator: (otp) =>
                          (otp != null && otp.isNotEmpty && otp.length == 6)
                              ? null
                              : 'Enter a valid OTP',
                      controller: controller.otpController,
                      textInputAction: TextInputAction.next,
                      label: 'OTP',
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      maxLength: 6,
                    ),
                    customSpacer,
                    InputField(
                      validator: (uname) => (uname != null &&
                              uname.isNotEmpty &&
                              uname.length > 6)
                          ? null
                          : 'UserName Should be of more than 6 characters',
                      controller: controller.displayNameController,
                      textInputAction: TextInputAction.done,
                      label: 'UserName',
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.name],
                      onSubmit: (_) {
                        if (_formKey.currentState?.validate() ?? false) {
                          controller.verifyOtp();
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
