import 'package:flutter/material.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

/*
* Get Key Pair
*/
Future<crypto.AsymmetricKeyPair> futureKeyPair;

//to store the KeyPair once we get data from our future
crypto.AsymmetricKeyPair keyPair;

Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
    getKeyPair() {
  var helper = RsaKeyHelper();
  return helper.computeRSAKeyPair(helper.getSecureRandom());
}

/*
 * Colors Constants Starts here
 */
const kPrimaryDarkColor = Color(0xFF2422DE);
const kPrimaryColor = Color(0xFF7199F7);
const kPrimaryLightColor = Color(0xFFF2F5FC);
const kDarkPurple = Color(0xFF1A1355);
const kPurple = Color(0xFFB3B3DD);
const kLightPurple = Color(0xFFEAEAF3);
const kAmber = Color(0xFFF2A61E);
const kDarkGray = Color(0xFF3F3836);
Color primary = Color(0xffF6F8FE);
Color primary1 = Color(0xff0D0D0E);
Color secondary = Color(0xff3D52FF);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    kPrimaryColor,
    kPrimaryLightColor,
  ],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF37303A);
/*
 * Colors Constants Ends here
 */

/*
 * Colors Constants Ends here
 */
const kAnimationDuration = Duration(milliseconds: 200);
final boxShadow = <BoxShadow>[
  BoxShadow(
    color: kPrimaryDarkColor.withOpacity(0.1),
    blurRadius: 16.0,
    offset: Offset(3, 3),
  ),
  BoxShadow(
    color: kPrimaryDarkColor.withOpacity(0.1),
    blurRadius: 16.0,
    offset: Offset(-3, -3),
  ),
];
BorderRadius defaultRadius = BorderRadius.circular(20);

double getElevation(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return 15;
  }
  return 5;
}

var statusList = <String>[
  'Hey there! I’m using KyaHaal',
  'Sleeping',
  'Busy',
  'At Work',
  'Emergency calls only!',
  'DND',
];

const String CONTACTAPI = "https://kyahaal.teamdrt.co.in/all";
const String APIKEY = "zEgZUcl8eD4MjWyy4nttT1nDrLPwRgvU1UH5chrQ";
const String MESSAGEENDPOINT = 'message';
const String USERSENDPOINT = 'users';

const headers = {"x-api-key": APIKEY};
// google.com, pub-6236661812187085, DIRECT, f08c47fec0942fa0
