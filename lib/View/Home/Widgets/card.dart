import 'package:flutter/material.dart';

class CardTask extends StatelessWidget {
  CardTask();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 15,
          bottom: 10,
          right: 12,
        ),
        width: 340.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.amber, width: 7.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Second Flutter App in Progress',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
              child: Text(
                'Believe it can be done. When you believe something can be done,'
                'really believe, your mind will find the ways to do it. Believing a'
                'solution paves the way to solution.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
