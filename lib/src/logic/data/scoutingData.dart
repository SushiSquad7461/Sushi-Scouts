import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/color/HexColor.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'dart:convert';

class Component {
  String name;
  List<String>? values;
  String component;
  String type;
  bool timeStamp;
  Component(this.name, this.type, this.component, this.timeStamp,
      {this.values});
}

class Section {
  late HexColor color;
  late int rows;
  late HexColor textColor;
  late HexColor darkColor;
  late HexColor darkTextColor;
  late String title;

  List<Component> components = [];
  List<Data> values = [];
  List<int> componentsPerRow = [];

  Section.cc(this.title, this.color, this.rows, this.textColor, this.components,
      this.values, this.componentsPerRow);

  Section(Map<String, dynamic> config) {
    title = config["properties"]["title"];
    color = HexColor(config["properties"]["color"]);
    rows = config["properties"]["rows"];
    textColor = HexColor(config["properties"]["textColor"]);
    darkColor = HexColor(config["properties"]["darkColor"]);
    darkTextColor = HexColor(config["properties"]["darkTextColor"]);
    componentsPerRow = List<int>.from(config["properties"]["componentsInRow"]);

    for (var i in config["components"]) {
      components.add(Component(
          i["name"], i["type"], i["component"], i["timestamp"],
          values: i["values"] == null ? null : List<String>.from(i["values"])));

      if (i["type"] == "number") {
        values.add(Data<double>(i["values"] != null ? i["values"][0] : 0));
      } else if (i["type"] == "string") {
        values.add(Data<String>(i["values"] != null ? i["values"][0] : ""));
      } else {
        throw ArgumentError("Type: ${i["type"]} is an invalid type2");
      }
    }
  }

  String stringfy() {
    String ret = "";

    for (int i = 0; i < values.length; ++i) {
      ret += '"${components[i].name}":"${values[i].get()}"';

      if (components[i].timeStamp) {
        ret += "T";
        ret += "{";

        for (var j in values[i].timestamps.keys) {
          ret += j.toString();
          ret += ":";

          if (components[i].type != "string") {
            ret += values[i].timestamps[j].toString();
          } else {
            ret += values[i].timestamps[j];
          }
          ret += ",";
        }
        ret += "}";
      }
    }

    return ret;
  }

  int numComponents() {
    return components.length;
  }

  void empty() {
    for (int i = 0; i < values.length; ++i) {
      if (components[i].values == null) {
        values[i].empty();
      } else {
        values[i].set(components[i].values![0]);
      }
    }
  }
}

class Page {
  late String footer;
  List<Section> sections = [];

  Page.cc(this.sections, this.footer);

  Page(Map<String, dynamic> config) {
    footer = config["footer"];

    for (var i in config["sections"]) {
      sections.add(Section(i));
    }
  }

  String stringfy() {
    String ret = "${footer[0].toUpperCase()}\n";

    for (var i in sections) {
      ret += i.stringfy();
    }

    return "$ret\n";
  }

  void empty() {
    for (var section in sections) {
      section.empty();
    }
  }

  int getComponentsPerRow(int currRow) {
    int ret = 0;
    for (Section i in sections) {
      ret += i.componentsPerRow[currRow];
    }
    return ret;
  }
}

class ScoutingData {
  String name;
  Map<String, Page> pages = {};
  List<String> pageNames = [];
  int currPage = 0;

  ScoutingData(Map<String, dynamic> config, {required this.name}) {
    for (String k in config.keys.toList()) {
      pageNames.add(k);
      pages[k] = Page(config[k]);
    }
  }

  bool canGoToNextPage() {
    return currPage < pageNames.length - 1;
  }

  bool canGoToPrevPage() {
    return currPage > 0;
  }

  bool nextPage() {
    if (!canGoToNextPage()) {
      return false;
    }
    currPage += 1;
    return true;
  }

  bool prevPage() {
    if (!canGoToPrevPage()) {
      return false;
    }
    currPage -= 1;
    return true;
  }

  String stringfy() {
    String ret = "${name[0].toUpperCase()}\n";

    for (var i in pages.values) {
      ret += i.stringfy();
    }

    return ret;
  }

  Page? getCurrentPage() {
    return pages[pageNames[currPage]];
  }

  void empty() {
    currPage = 0;
    for (var page in pageNames) {
      pages[page]!.empty();
    }
  }
}
