import 'package:flutter/material.dart';

Widget button(
    {required tittel,
    required size,
    required void Function() onPressed,
    required context}) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    decoration: BoxDecoration(
        color: Colors.green, borderRadius: BorderRadius.circular(12)),
    child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            const Icon(
              Icons.download,
              color: Colors.white,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              tittel,
              style:
                  TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              size,
              style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Color.fromARGB(255, 0, 0, 0)),
            )
          ],
        )),
  );
}

Widget massageWidget(
    {required String msg,
    required Color color,
    required screenWidth,
    required Icon icons}) {
  return Column(
    children: [
      Text(
        msg,
        style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: color),
      ),
      Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color.fromARGB(255, 214, 221, 225)),
        child:
            Padding(padding: EdgeInsets.all(screenWidth * 0.02), child: icons),
      ),
    ],
  );
}

String formatDuration(Duration duration) {
  if (duration.inSeconds < 60) {
    return '${duration.inSeconds}s';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes}m';
  } else {
    return '${duration.inHours}h';
  }
}
