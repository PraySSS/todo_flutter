import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    super.key,
    required this.text,
    this.controller,
    required this.obscureText,
    this.maxLineTextField,
    this.textFieldHeight,
    required this.horizontalSize,
  });

  final String text;
  final TextEditingController? controller;
  final bool obscureText;
  final int? maxLineTextField;
  final double horizontalSize;
  final double? textFieldHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSize),
      child: Container(
        height: textFieldHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: HexColor('#ffffff'),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: -1,
              blurRadius: 12,
              color: Color.fromRGBO(155, 155, 155, 0.73),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            validator: text == 'Email'
                ? MultiValidator([
                    RequiredValidator(errorText: "Email required"),
                    EmailValidator(errorText: "Please insert a valid email")
                  ])
                : RequiredValidator(errorText: '$text required'),
            style: TextStyle(color: HexColor('#666161'), fontSize: 16),
            // To hide password in with dot
            obscureText: obscureText,
            controller: controller, minLines: 1, maxLines: maxLineTextField,
            decoration: InputDecoration(
              labelText: text,
              hintText: 'Enter $text',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
