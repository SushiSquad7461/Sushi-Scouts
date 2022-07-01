import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/views/ui/Scouting.dart';

import 'ScoutingData.dart';

class ConfigFileReader {
  String configFileFolder;
  int year;
  Map<String, dynamic>? parsedFile;

  ConfigFileReader(this.configFileFolder, this.year);

  Future<void> readConfig() async {
    try {
      final String stringifiedFile =
          await rootBundle.loadString("$configFileFolder${year}config");
      parsedFile = await json.decode(stringifiedFile);
    } catch (e) {
      rethrow;
    }
  }

  List<String> getScoutingMethods() {
    return parsedFile != null ? parsedFile!.keys.toList() : [];
  }

  ScoutingData generateScoutingData(String scoutingMethod) {
    return ScoutingData(parsedFile![scoutingMethod], scoutingMethod);
  }

  List<ScoutingData> getScoutingDataClasses() {
    List<ScoutingData> ret = [];
    for (var scoutingMethod in parsedFile!.keys) {
      ret.add(ScoutingData(parsedFile![scoutingMethod], scoutingMethod));
    }
    return ret;
  }
}
