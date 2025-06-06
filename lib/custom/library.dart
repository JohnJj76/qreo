import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:qreo/pages/orion/verif_orion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/pages/eros/form_eros.dart';
import 'package:qreo/pages/eros/verif_eros.dart';
import 'package:qreo/pages/orion/form_orion.dart';
import 'package:qreo/pages/login/splash_page.dart';
import 'package:qreo/widgets/loading.dart';

enum CustomPage { splash, formEros, formOrion, verifEros, verifOrion }

enum TypeAnimation { transition }

enum Preference { onboarding }

BuildContext? globalContext;

// Register the RouteObserver as a navigation observer.
final RouteObserver<ModalRoute<void>> mRouteObserver =
    RouteObserver<ModalRoute<void>>();

navigate(
  BuildContext mContext,
  CustomPage mPage, {
  bool finishCurrent = false,
}) {
  if (finishCurrent) {
    Navigator.pop(globalContext!);
  }

  switch (mPage) {
    case CustomPage.splash:
      Navigator.pushAndRemoveUntil(
        globalContext!,
        _goPage(const SplashPage(), TypeAnimation.transition, 500),
        (Route<dynamic> route) => false,
      );
      break;

    case CustomPage.formEros:
      Navigator.push(
        globalContext!,
        _goPage(const FormEros(), TypeAnimation.transition, 500),
      );
      break;

    case CustomPage.formOrion:
      Navigator.push(
        globalContext!,
        _goPage(const FormOrion(), TypeAnimation.transition, 500),
      );
      break;

    case CustomPage.verifEros:
      Navigator.pushAndRemoveUntil(
        globalContext!,
        _goPage(const VerifEros(), TypeAnimation.transition, 500),
        (Route<dynamic> route) => false,
      );
      break;

    case CustomPage.verifOrion:
      Navigator.pushAndRemoveUntil(
        globalContext!,
        _goPage(const VerifOrion(), TypeAnimation.transition, 500),
        (Route<dynamic> route) => false,
      );
      break;
    default:
  }
}

Route _goPage(Widget page, TypeAnimation type, int milliseconds) {
  return PageRouteBuilder(
    pageBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) => page,
    transitionDuration: Duration(milliseconds: milliseconds),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final mCurveAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInBack,
      );

      switch (type) {
        case TypeAnimation.transition:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(mCurveAnimation),
            child: child,
          );
      }
    },
  );
}

// para convertir un color hexadecimal en un color de flutter
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

setOnePreference(Preference mAuxKey, String value) async {
  String mKey = '';
  switch (mAuxKey) {
    case Preference.onboarding:
      mKey = 'onboarding';
      break;
    default:
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(mKey, value);
}

getOnePreference(Preference mAuxKey) async {
  String mKey = '';
  switch (mAuxKey) {
    case Preference.onboarding:
      mKey = 'onboarding';
      break;
    default:
  }

  String result = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkValue = prefs.containsKey(mKey);
  if (checkValue) {
    result = prefs.getString(mKey) ?? '';
  }

  return result;
}

customShowToast(BuildContext context, String message) {
  int mTime = (message.length / 3).round();
  mTime = mTime < 0 ? 1 : mTime;

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: mTime,
    backgroundColor: Constants.colorAccent,
    textColor: Constants.colorWhite,
    fontSize: 14.0,
  );
}

progressDialogShow(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
  OverlayLoadingProgress.start(
    context,
    barrierDismissible: false,
    widget: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 50,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Consultando...", style: Constants.textStyleBlackBold),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Loading(
                mColor: Constants.colorBlack,
                mIndicator: Indicator.ballBeat,
                mSize: 5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

dialogDismiss() {
  OverlayLoadingProgress.stop();
}
