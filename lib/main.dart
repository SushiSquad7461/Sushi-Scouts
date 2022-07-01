import 'dart:io';

import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ConfigFileReader.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
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
  late final Map<String, ScoutingData> scoutingPages = {};
  late final List<String> _headerNavNeeded;

  void setCurrentPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();
    // readInNewConfigFile();
  }

  // Future<void> readInNewConfigFile() async {
  //   await fileReader.readConfig();
  //   setState(() {
  //     _headerNavNeeded = fileReader.getScoutingMethods();
  //     _headerNavNeeded.add("settings");

  //     for (var scoutingMethod in fileReader.getScoutingMethods()) {
  //       _pages[scoutingMethod] = const MaterialPage(
  //           child: Scouting(fileReader: fileReader, name: scoutingMethod));
  //     }

  //     _currentPage = "login";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder<void>(
            future: fileReader.readConfig(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<ScoutingData> scoutingPagesList =
                    fileReader.getScoutingDataClasses();

                for (var i in scoutingPagesList) {
                  scoutingPages[i.scoutingMethodName] = i;
                }

                Size mediaQuerySize = MediaQuery.of(context).size;

                return Scaffold(
                    body: Column(children: [
                  HeaderTitle(size: mediaQuerySize),
                  Navigator(
                    pages: [
                      if (_currentPage == "login")
                        const MaterialPage(child: Login())
                      else if (fileReader
                          .getScoutingMethods()
                          .contains(_currentPage))
                        MaterialPage(
                            child: Scouting(name: scoutingPages[_currentPage]!))
                    ],
                    onPopPage: (route, result) {
                      return route.didPop(result);
                    },
                  ),
                ]));
              } else if (snapshot.hasError) {
                return Text("Error bad: ${snapshot.error}");
              } else {
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
