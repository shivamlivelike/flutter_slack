import 'package:flutter/material.dart';

import 'skin_tones.dart';

class SkinDot extends StatelessWidget {
  final int? skin;

  const SkinDot({Key? key, this.skin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: SkinTones.tones[skin!],
        shape: BoxShape.circle,
      ),
    );
  }
}
