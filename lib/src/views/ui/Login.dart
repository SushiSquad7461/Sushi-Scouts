import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            const HeaderTitle(),
            Padding(
              padding: const EdgeInsets.only(top: 536),
              child: SizedBox(
                  width: 340,
                  height: 340,
                  child: SvgPicture.asset("./assets/images/angledbar.svg",)
              ),
            ),
          ],
        )
    );
  }
}