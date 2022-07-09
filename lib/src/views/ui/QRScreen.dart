import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/header/HeaderNav.dart';
import 'Scouting.dart';

class QRScreen extends StatelessWidget {
  final Function(String) changePage;
  final String previousPage;
  final ScoutingData data;
  String? stringifiedData;

  QRScreen(
      {Key? key,
      required this.changePage,
      required this.previousPage,
      required this.data})
      : super(key: key);

  void convertData() {
    stringifiedData = data.stringfy();
    print(stringifiedData!.length);
  }

  @override
  Widget build(BuildContext context) {
    convertData();
    data.empty();
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
            alignment: Alignment(0, -0.5),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: ScreenSize.width * 0.8,
                  height: ScreenSize.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenSize.width * 0.1))),
                ),
                Container(
                  width: ScreenSize.width * 0.7,
                  height: ScreenSize.width * 0.7,
                  color: Colors.white,
                ),
                SizedBox(
                  height: (0.7 * ScreenSize.width),
                  child: QrImage(data: stringifiedData!),
                ),
              ],
            )),
        Align(
            alignment: Alignment(0, 1),
            child: SvgPicture.asset(
              "./assets/images/FooterColors.svg",
              width: ScreenSize.width,
            )),
        Align(
          alignment: Alignment(0, 0.83),
          child: Container(
              width: ScreenSize.width,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: TextButton(
                onPressed: () => changePage(previousPage),
                child: Text(
                  'CONTINUE',
                  style: TextStyle(
                      fontSize: 35 * ScreenSize.swu,
                      fontFamily: "Sushi",
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }
}
