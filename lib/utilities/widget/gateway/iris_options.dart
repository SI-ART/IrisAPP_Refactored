import 'package:flutter/material.dart';

class IrisOptionList extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;
  final VoidCallback press;

  const IrisOptionList(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10.0),
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: null,
      ),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        onTap: press,
      ),
    );
  }
}
