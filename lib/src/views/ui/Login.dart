import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? teamNum;
  String? eventCode;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: ScreenSize.screenWidth * 0.7,
          height: 110,
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) => setState(() {
                  eventCode = value;
                }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
