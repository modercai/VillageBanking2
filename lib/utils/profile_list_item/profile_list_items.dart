import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final iconData;
  final String text;
  const ProfileListItem({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(iconData),
              SizedBox(
                width: 10,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
