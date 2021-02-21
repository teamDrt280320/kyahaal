import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kyahaal/global/Screens.dart';
import 'package:kyahaal/global/helper/customwidget.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/services/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:image_picker/image_picker.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser>
    with SingleTickerProviderStateMixin {
  TextEditingController controller;
  TextEditingController controller2;
  TextEditingController controller3;
  FocusNode focusNode = FocusNode();
  var otpSent = false;
  var showError = false;
  var showLoaing = false;
  String error;
  UserBloc bloc;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  AnimationController btnController;
  double _scale;
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: File(pickedFile.path).absolute.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          activeControlsWidgetColor: Colors.amber,
          showCropGrid: true,
          toolbarTitle: 'Crop Your Image',
          toolbarColor: KHColor.brandColorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      setState(() {
        if (croppedFile != null) {
          print(croppedFile.path);
          _image = File(croppedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //focusNode.nextFocus();
    btnController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(
        () {
          setState(() {});
        },
      );
    controller = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    bloc = UserBloc();
    controller.addListener(
      () {
        if (controller.text.isEmpty) {
          if (mounted) {
            setState(
              () {
                showError = false;
                otpSent = false;
              },
            );
          }
        } else {
          if (mounted) {
            setState(
              () {
                showError = false;
              },
            );
          }
        }
      },
    );
    bloc.otpController.stream.listen(
      (event) {
        if (mounted) {
          setState(
            () {
              otpSent = event;
            },
          );
        }
      },
    );
    bloc.verifyErrorController.stream.listen(
      (event) {
        if (event.isNotEmpty) {
          if (mounted) {
            errorController.add(ErrorAnimationType.shake);
            setState(
              () {
                showError = true;
                error = event;
              },
            );
          }
        } else {
          if (mounted) {
            setState(
              () {
                showError = false;
              },
            );
          }
        }
      },
    );
    bloc.loadController.stream.listen((event) {
      if (mounted) {
        setState(
          () {
            showLoaing = event;
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(() {});
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - btnController.value;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                text: "Welcome\nOnboard",
              ),
              StepsText(
                text: otpSent ? "2" : "1",
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: ProfilePIcture(
              child: _image == null
                  ? null
                  : ClipOval(
                      child: Image.file(_image),
                    ),
              onTap: () {
                if (!otpSent && !showLoaing) {
                  buildShowModalBottomSheet(context);
                }
              },
            ),
          ),
          Container(
            child: PhoneNumberTextField(
              focusNode: focusNode,
              controller: controller,
              readOnly: otpSent && !showLoaing,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextField(
              controller: controller3,
              readOnly: otpSent && !showLoaing,
              maxLength: 20,
              style: GoogleFonts.openSans(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                counter: null,
                counterStyle: TextStyle(
                  color: Colors.amber,
                ),
                //prefixText: "+91",
                prefixStyle: GoogleFonts.openSans(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                labelText: "UserName".toUpperCase(),
                labelStyle: GoogleFonts.openSans(
                  color: Colors.white,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                focusColor: Colors.orange,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber,
                    width: 2.2,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white30,
                    width: 2.2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: otpSent,
            child: OTP(
              controller3: controller3,
              image: _image,
              errorController: errorController,
              controller2: controller2,
              bloc: bloc,
            ),
          ),
          Visibility(
            visible: otpSent,
            child: SizedBox(
              height: 30,
            ),
          ),
          Visibility(
            visible: showError,
            child: KHErrorWidget(error: error),
          ),
          Visibility(
            child: SizedBox(
              height: 15,
            ),
            visible: showError,
          ),
          Visibility(
            visible: showLoaing,
            child: Column(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: _scale,
            child: NextButton(
              text: otpSent ? "VERIFY OTP" : "GET OTP",
              onTap: () {
                if (!showLoaing) {
                  btnController
                      .forward()
                      .then((value) => btnController.reverse());

                  if (showError) {
                    setState(
                      () {
                        showError = false;
                      },
                    );
                  }
                  otpSent
                      ? bloc.verify(controller2.text, controller3.text, _image)
                      : bloc.signIn(controller.text, controller3.text, _image);
                }
              },
              onTapDown: (abc) {},
            ),
          ),
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView(
            children: [
              Visibility(
                visible: _image != null,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FullScreenDP(
                          image: _image,
                        );
                      },
                    ));
                    //
                  },
                  leading: Icon(
                    Icons.open_in_full,
                    color: KHColor.brandColorPrimary,
                  ),
                  title: Text(
                    "View Photo",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: KHColor.brandColorPrimary,
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.camera_enhance,
                  color: KHColor.brandColorPrimary,
                ),
                title: Text(
                  "Capture from Camera",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: KHColor.brandColorPrimary,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.image_outlined,
                  color: KHColor.brandColorPrimary,
                ),
                title: Text(
                  "Select Image from Gallery",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: KHColor.brandColorPrimary,
                  ),
                ),
              ),
              Visibility(
                visible: _image != null,
                child: ListTile(
                  onTap: () {
                    setState(
                      () {
                        _image = null;
                      },
                    );
                    Navigator.pop(context);
                  },
                  leading: Icon(
                    Icons.delete,
                    color: KHColor.brandColorPrimary,
                  ),
                  title: Text(
                    "Remove Image",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: KHColor.brandColorPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  final void Function() onTap;
  final void Function(TapDownDetails abc) onTapDown;
  final String text;
  NextButton({
    Key key,
    this.onTap,
    this.text,
    this.onTapDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Color(0xff212223),
      color: Color(0xff212223),
      elevation: 5,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTapDown: onTapDown,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            color: Color(0xff212223),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.openSans(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
