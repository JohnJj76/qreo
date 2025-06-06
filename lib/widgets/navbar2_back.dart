import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/widgets/custom_button.dart';

enum Tinte { dark, light }

class Navbar2Back extends StatelessWidget implements PreferredSizeWidget {
  const Navbar2Back({
    super.key,
    this.title,
    this.backgroundColor,
    this.backgroundButtonColor,
    this.tinte,
    this.showBack = false,
    this.showMenu = false,
    this.goBack,
    this.mListActions,
    this.menu,
    this.leading,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  final String? title;
  final Color? backgroundColor;
  final Color? backgroundButtonColor;
  final Tinte? tinte;
  final bool? showBack;
  final bool? showMenu;
  final Function? goBack;
  final List<Widget>? mListActions;
  final Widget? menu;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor:
            (tinte == Tinte.light ? Constants.colorDark : Constants.colorLight),

        // Status bar brightness (optional)
        statusBarIconBrightness:
            (tinte == Tinte.light
                ? Brightness.light
                : Brightness.dark), // For Android (dark icons)
        statusBarBrightness:
            (tinte == Tinte.light
                ? Brightness.light
                : Brightness.dark), // For iOS (dark icons)
      ),
      surfaceTintColor: (backgroundColor ?? Constants.colorBackgroundLayout),
      backgroundColor: (backgroundColor ?? Constants.colorBackgroundLayout),
      iconTheme: const IconThemeData(),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              'assets/imagenes/logo2.png',
              width: 55,
              height: 40,
            ),
          ),
          SizedBox(width: 16),
          Container(
            color: (backgroundColor ?? Constants.colorBackgroundLayout),
            child: Text(
              (title == null ? "" : title!),
              style:
                  (tinte == Tinte.light
                      ? Constants.textStyleBlackTitle
                      : Constants.textStyleWhiteTitle),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      elevation: 0,
      leading:
          (showBack == true
              ? Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.radius),
                  color:
                      (tinte == Tinte.light
                          ? Constants.colorWhite
                          : Constants.colorDark),
                ),
                child: CustomButton(
                  color: Colors.transparent,
                  child: Icon(
                    TablerIcons.chevron_left,
                    color:
                        (tinte == Tinte.light
                            ? Constants.colorDark
                            : Constants.colorLight),
                    size: 30,
                  ),
                  callback: () {
                    Navigator.of(context).pop();
                    // if the navigator received a callback function, call it
                    if (goBack != null) {
                      goBack!();
                    }
                  },
                ),
              )
              : (showMenu == true
                  ? CustomButton(
                    color: Constants.colorBackgroundLayout,
                    borderRadius: 500,
                    child: Icon(
                      TablerIcons.menu,
                      color:
                          (tinte == Tinte.light
                              ? Constants.colorBlack
                              : Constants.colorWhite),
                      size: 22,
                    ),
                    callback: () => Scaffold.of(context).openDrawer(),
                  )
                  : null)),
      actions: mListActions,
    );
  }
}
