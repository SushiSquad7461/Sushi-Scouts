import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'dart:convert';

const String CONFIG_PATH = "assets/config/config.json";

class ComponentInfo {
  String name;
  List<String> values;
  String color;
  String component;

  ComponentInfo(this.name, this.color, this.component, this.values);
}

class Component {
  late ComponentInfo info;
  late Data data;

  String stringfy() {
    String name = info.name;
    String currVal = data.get();
    return "\"$name\":\"$currVal\"\n";
  }

  Component.cc(this.data, this.info);

  Component(Map<String, dynamic> parsedConfigFileComp) {
    String type = parsedConfigFileComp["type"];

    var defualtVal = (parsedConfigFileComp["values"] as List<dynamic>).isEmpty
        ? null
        : parsedConfigFileComp["values"][0];

    if (type == "string") {
      data = Data<String>(defualtVal ?? "");
    } else if (type == "number") {
      data = Data<double>(defualtVal ?? 0);
    } else {
      throw Exception("Config File Invalid, Type: $type is not a valid type");
    }

    info = ComponentInfo(
        parsedConfigFileComp["name"],
        parsedConfigFileComp["color"],
        parsedConfigFileComp["component"],
        parsedConfigFileComp["values"]);
  }
}

class Section {
  late String name;
  late String footerString;
  late String orientation;
  late List<Component> components;

  String stringfy() {
    String capitalFirstChar = name[0].toUpperCase();
    String ret = "$capitalFirstChar\n";

    for (var i in components) {
      ret += i.stringfy();
    }

    return ret;
  }

  Section.cc(this.name, this.footerString, this.orientation, this.components);

  Section(Map<String, dynamic> parsedConfigFileSection, this.name) {
    footerString = parsedConfigFileSection["properties"]["footer"] as String;
    orientation =
        parsedConfigFileSection["properties"]["orientation"] as String;

    for (var component in parsedConfigFileSection["components"]) {
      components.add(Component(component));
    }
  }
}

class ScoutingData {
  String scoutingMethodName;
  int currentStage;
  Map<String, Section> sections = {};

  ScoutingData.cc(this.sections, this.scoutingMethodName,
      {this.currentStage = 0});

  ScoutingData(Map<String, dynamic> parsedConfigFile, this.scoutingMethodName,
      {this.currentStage = 0}) {
    for (var k in parsedConfigFile.keys) {
      sections[k] = Section(parsedConfigFile[k], k);
    }
  }

  bool goToNextStage() {
    if (currentStage >= sections.keys.length - 1) {
      return false;
    }
    currentStage += 1;
    return true;
  }

  bool goToPrevStage() {
    if (currentStage <= 0) {
      return false;
    }
    currentStage += 1;
    return true;
  }

  List<String> getStages() {
    return sections.keys.toList();
  }

  String stringfy() {
    String ret = "${scoutingMethodName[0].toUpperCase()}\n";

    for (var i in sections.values) {
      ret += i.stringfy();
    }

    return ret;
  }
}
