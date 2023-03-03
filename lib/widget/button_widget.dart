import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.textButton,
    required this.press,
  });
  final String textButton;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      //ทำให้ขยายข้างออกเพราะถ้าไม่ใส่ขอบจะลดเท่าตัวอักษรด้านใน
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: -1,
            blurRadius: 12,
            color: Color.fromRGBO(155, 155, 155, 0.73),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            // ใส่ 0xff ข้างหน้าและใส่รหัสสีเป็น HEX ด้านหลัง
            Color(0xff53CD9F),
            Color(0xff0D7A5C),
          ],
        ),
      ),
      child: TextButton(
        onPressed: press,
        child: Text(textButton),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20.0),
          textStyle: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
