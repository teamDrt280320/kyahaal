import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/sized_config.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:line_icons/line_icons.dart';

class CompleteSetupPageMobile extends StatefulWidget {
  @override
  _CompleteSetupPageMobileState createState() =>
      _CompleteSetupPageMobileState();
}

class _CompleteSetupPageMobileState extends State<CompleteSetupPageMobile> {
  AuthController _controller = Get.find();
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          'Setup Profile',
          style: GoogleFonts.openSans(
            color: kDarkPurple,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                      image: _controller.image.value == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(_controller.image.value),
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryDarkColor.withOpacity(0.1),
                          blurRadius: 10.0,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    height: 144,
                    width: 144,
                    child: _controller.image.value == null
                        ? Icon(
                            LineIcons.user,
                            size: 96,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryLightColor,
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            title: Text(
                              'Select an option',
                              style: GoogleFonts.openSans(
                                fontSize: 24,
                              ),
                            ),
                            message: const Text('Select a source of the Image'),
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text('Gallery'),
                                onPressed: () async {
                                  var imagePicked = await _picker.getImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (imagePicked != null) {
                                    var file = await ImageCropper.cropImage(
                                      aspectRatio:
                                          CropAspectRatio(ratioX: 1, ratioY: 1),
                                      sourcePath: imagePicked.path,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square,
                                      ],
                                      androidUiSettings: AndroidUiSettings(
                                        activeControlsWidgetColor:
                                            kPrimaryColor,
                                      ),
                                      iosUiSettings: IOSUiSettings(
                                        minimumAspectRatio: 1,
                                        rectX: 1,
                                        rectY: 1,
                                        showCancelConfirmationDialog: true,
                                        aspectRatioPickerButtonHidden: true,
                                        aspectRatioLockEnabled: true,
                                      ),
                                    );
                                    if (file != null) {
                                      _controller.image.value =
                                          await file.readAsBytes();
                                    }
                                  }

                                  Get.back();
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('Camera'),
                                onPressed: () async {
                                  var imagePicked = await _picker.getImage(
                                    source: ImageSource.camera,
                                  );
                                  if (imagePicked != null) {
                                    var file = await ImageCropper.cropImage(
                                      aspectRatio:
                                          CropAspectRatio(ratioX: 1, ratioY: 1),
                                      sourcePath: imagePicked.path,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square,
                                      ],
                                      androidUiSettings: AndroidUiSettings(
                                        activeControlsWidgetColor:
                                            kPrimaryColor,
                                      ),
                                      iosUiSettings: IOSUiSettings(
                                        minimumAspectRatio: 1,
                                        rectX: 1,
                                        rectY: 1,
                                        showCancelConfirmationDialog: true,
                                        aspectRatioPickerButtonHidden: true,
                                        aspectRatioLockEnabled: true,
                                      ),
                                    );
                                    if (file != null) {
                                      _controller.image.value =
                                          await file.readAsBytes();
                                    }
                                  }

                                  Get.back();
                                },
                              ),
                              Obx(
                                () => Visibility(
                                  visible: _controller.image.value != null,
                                  child: CupertinoActionSheetAction(
                                    child: const Text('Remove Photo'),
                                    onPressed: () {
                                      _controller.image.value = null;
                                      Get.back();
                                    },
                                  ),
                                ),
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: kTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            Container(
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                boxShadow: boxShadow,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextFormField(
                cursorColor: kPrimaryColor,
                controller: _controller.userName,
                decoration: InputDecoration(
                  labelText: 'Enter Username',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: boxShadow,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        _controller.firestoreUser.value.status,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            title: Text(
                              'Select a status',
                              style: GoogleFonts.openSans(
                                fontSize: 24,
                              ),
                            ),
                            message: const Text(
                              'Select a Source or add a custom one',
                            ),
                            actions: [
                              ...List.generate(
                                statusList.length + 1,
                                (index) => index == statusList.length
                                    ? CupertinoActionSheetAction(
                                        child: Text('Custom'),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      )
                                    : CupertinoActionSheetAction(
                                        child: Text(statusList[index]),
                                        onPressed: () {
                                          _controller.firestoreUser.value =
                                              _controller.firestoreUser.value
                                                ..status = statusList[index];

                                          Get.back();
                                          setState(() {});
                                        },
                                      ),
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        );
                      },
                      child: Text('Change'),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  kDarkPurple,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(
                    SizeConfig.screenWidth * 0.7,
                    SizeConfig.screenHeight * 0.07,
                  ),
                ),
                elevation: MaterialStateProperty.resolveWith(
                  (states) => getElevation(states),
                ),
                shadowColor: MaterialStateProperty.all(
                  kDarkPurple,
                ),
              ),
              icon: Icon(
                LineIcons.save,
                size: 36,
                color: kLightPurple,
              ),
              onPressed: () {
                _controller
                    .completeSetup(_controller.firestoreUser.value.status);
              },
              label: Obx(
                () => _controller.signingIn.value
                    ? CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(kLightPurple),
                      )
                    : Text(
                        'Save',
                        style: GoogleFonts.openSans(
                          color: kLightPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
