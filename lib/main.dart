import "package:flutter/material.dart";
import 'package:sushi_scouts/src/views/util/footer.dart';
import 'package:sushi_scouts/src/views/util/Header/HeaderTitle.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';

void main() => runApp(SushiScouts());

class SushiScouts extends StatelessWidget {
  const SushiScouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: const [
            HeaderTitle(),
            HeaderNav(currentPage: "ORDINAL"),
            Footer(nextPage: true, previousPage: true, pageTitle: "AUTO",),
          ],
        )
      )
    );
  }
}