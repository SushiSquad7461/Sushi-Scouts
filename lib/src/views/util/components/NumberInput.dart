import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class NumberInput extends StatelessWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;

  NumberInput({Key? key, required this.name, required this.data, required this.color, required this.width, required this.textColor})
    : super(key: key);

  static NumberInput create(String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return NumberInput(name: name, data: data, width: width, color: color, textColor: textColor,);
  }

  @override
  Widget build(BuildContext context) {
    data.set(double.parse(data.get()));
    return Padding(
        padding:
            EdgeInsets.only(left: width/60, right: width/60, top: width/30, bottom: width/30),
        child: SizedBox(
          width: width*0.9,
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Text(name.toUpperCase(),
              //   style: GoogleFonts.mohave(
              //     textStyle: TextStyle(
              //       fontSize: width/8,
              //       fontWeight: FontWeight.w400,
              //       color:  textColor
              //     )
              //   ),
              // ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    constraints: BoxConstraints(maxWidth: width/6.0),
                    hintText: name.toUpperCase(),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: GoogleFonts.mohave(
                    textStyle: TextStyle(
                      fontSize: width/8,
                      fontWeight: FontWeight.w400,
                      color:  textColor
                    )
                  ), 
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onFieldSubmitted: (value) {
                    data.set(double.parse(value));
                  }
                )
              )
            ]),
            Divider(color: textColor, thickness: width/50)
            ]
          )
        )
    );
  }
}
