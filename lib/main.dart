import 'dart:io';

import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ConfigFileReader.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/ui/Loading.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';
import 'package:sushi_scouts/src/views/ui/Scouting.dart';
import 'package:sushi_scouts/src/views/ui/Settings.dart';
import 'package:sushi_scouts/src/views/util/footer.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderTitle.dart';

void main() => runApp(const SushiScouts());

class SushiScouts extends StatefulWidget {
  const SushiScouts({Key? key}) : super(key: key);

  @override
  State<SushiScouts> createState() => _SushiScoutsState();
}

class _SushiScoutsState extends State<SushiScouts> {
  // CHANGE HOW YEAR WORKS
  ConfigFileReader fileReader = ConfigFileReader(CONFIG_FILE_PATH, 2022);
  String _currentPage = "login";
  Map<String, ScoutingData> scoutingPages = {};
  List<String> _headerNavNeeded = [];

  // Change current page
  void setCurrentPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder<void>(
            // Read in config
            future: fileReader.readConfig(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (ScreenSize.screenWidth == 0 || ScreenSize.screenHeight == 0) {
                // Set width and height of screen
                ScreenSize.screenWidth = MediaQuery.of(context).size.width;
                ScreenSize.screenHeight = MediaQuery.of(context).size.height;
              }

              if (snapshot.connectionState == ConnectionState.done) {
                for (var i in fileReader.getScoutingDataClasses()) {
                  scoutingPages[i.scoutingMethodName] = i;
                }

                _headerNavNeeded = fileReader.getScoutingMethods();
                _headerNavNeeded.add("settings");

                return Scaffold(
                    body: Column(children: [
                  const HeaderTitle(),
                  if (true)
                    HeaderNav(
                        currentPage: _currentPage,
                        changePage: setCurrentPage,
                        screens: _headerNavNeeded),
                  // Navigator(
                  //   pages: [
                  //     if (_currentPage == "login")
                  //       const MaterialPage(child: Login())
                  //     else if (fileReader
                  //         .getScoutingMethods()
                  //         .contains(_currentPage))
                  //       MaterialPage(
                  //           child: Scouting(name: scoutingPages[_currentPage]!))
                  //   ],
                  //   onPopPage: (route, result) {
                  //     return route.didPop(result);
                  //   },
                  // ),
                ]));
              } else if (snapshot.hasError) {
                // Error happened while reading in file
                return Text("Error bad: ${snapshot.error}");
              } else {
                // Have not read in file yet
                return const Loading();
              }
            })

        // Navigator(
        // pages: [_pages[_currentPage]!],
        // onPopPage: (route, result) {
        //   return route.didPop(result);
        // },
        );
  }
}
