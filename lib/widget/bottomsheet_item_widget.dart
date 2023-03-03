import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hexcolor/hexcolor.dart';

class BottomSheetItemWidget extends StatelessWidget {
  const BottomSheetItemWidget({
    super.key,
    required this.uriSvg,
    required this.text,
    required this.press,
  });
  final String uriSvg;
  final String text;
  final Function() press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      //To make entire row can clickable
      child: InkWell(
        onTap: press,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 35,
                    color: HexColor("#3CB189"),
                    icon: ImageIcon(Svg(uriSvg)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: HexColor('#0D7A5C')),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: HexColor('#0D7A5C'),
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
