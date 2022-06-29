import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/views/ui/Scouting.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';
import 'package:sushi_scouts/src/views/ui/Settings.dart';
import 'package:sushi_scouts/src/views/util/footer.dart';
import 'package:sushi_scouts/src/views/util/Header/HeaderTitle.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';

void main() => runApp(const SushiScouts());

class SushiScouts extends StatefulWidget {
  const SushiScouts({Key? key}) : super(key: key);
  //CardinalData data = await CardinalData.create();
  @override
  State<SushiScouts> createState() => _SushiScoutsState();
}

class _SushiScoutsState extends State<SushiScouts> {
  // TODO: CHANGE VAL TO Pages.login WHEN LOGIN PAGE IS MADE
  String _currentPage = "ordinal";
  String _previousPage = "ordinal";
  Map<String, ScoutingData?> previousData = {};
  List<String>? screens;
  final  GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();

  Future<bool> _setScreens() async{
    screens = await ScoutingData.getScreens();
    for(String screen in screens!) {
      previousData[screen] = null;
    }
    return true;
  }

  void setCurrentPage(String newPage, String previousPage, {ScoutingData? previousData=null}) {
    if(previousData != null){
      this.previousData[previousPage] = previousData;
    }
    if(previousPage != null) {
      _previousPage = previousPage;
    }
    setState(() {
      _currentPage = newPage;
    });
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    print(_currentPage);
    return MaterialApp(
      home: screens==null ?
      FutureBuilder(
        future: _setScreens(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ?
            Navigator(
              key: navigatorKey,
              pages: <Page<void>>[
                if(_currentPage=="qrcode")
                  MaterialPage(child: QRScreen(changePage: setCurrentPage, previousPage: _previousPage, data: previousData[_previousPage], screens: screens!))
                else if(_currentPage=="settings")
                  MaterialPage(child: Settings(changePage: setCurrentPage, screens: screens!))
                else if(_currentPage=="login")
                  MaterialPage(child: Login())
                else if(screens!.contains(_currentPage))
                   MaterialPage(child: Scouting(screen: _currentPage, changePage: setCurrentPage, previousData: previousData[_currentPage], screens: screens!))
                else
                  MaterialPage(child: Text("page does not exist"))
              ],
              onPopPage: (route, result) {
                return route.didPop(result);
              }) : 
            const CircularProgressIndicator();
        }) : 
      Navigator(
        key: navigatorKey,
        pages: <Page<void>>[
          if(_currentPage=="qrcode")
            MaterialPage(child: QRScreen(changePage: setCurrentPage, previousPage: _previousPage, data: previousData[_previousPage], screens: screens!))
          else if(_currentPage=="settings")
            MaterialPage(child: Settings(changePage: setCurrentPage, screens: screens!))
          else if(_currentPage=="login")
            MaterialPage(child: Login())
          else if(screens!.contains(_currentPage))
              MaterialPage(child: Scouting(screen: _currentPage, changePage: setCurrentPage, previousData: previousData[_currentPage], screens: screens!))
          else
            MaterialPage(child: Text("page does not exist"))
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        }
      )
    );
  }
}