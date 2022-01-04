import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iris/utilities/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final VoidCallback press;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double item = height * 0.7 - 200;
    double itemSize = item / 5;

    return Container(
      height: itemSize,
      margin: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 4,
      ).copyWith(
        bottom: kSpacingUnit.w * 2,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kSpacingUnit.w * 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
      ),
      child: InkWell(
        onTap: press,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: kSpacingUnit.w * 2.5,
              color: Colors.black,
            ),
            SizedBox(width: kSpacingUnit.w * 1.5),
            Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Schyler',
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
