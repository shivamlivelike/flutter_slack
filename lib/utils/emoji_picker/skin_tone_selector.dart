import 'package:flutter/material.dart';

import 'skin_dot.dart';
import 'skin_tones.dart';

class SkinToneSelector extends StatefulWidget {
  final Function(int) onSkinChanged;
  final double width;
  final double height;
  final int columns;

  const SkinToneSelector({
    Key? key,
    required this.onSkinChanged,
    required this.width,
    required this.height,
    required this.columns,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SkinToneState();
}

class _SkinToneState extends State<SkinToneSelector> {
  int _skin = 0;
  late OverlayEntry _overlayEntry;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return SkinDotButton(
      skin: _skin,
      onPressed: () {
        if (_expanded) {
          _overlayEntry.remove();
        } else {
          _overlayEntry = createOverlay(context);
          Overlay.of(context)!.insert(_overlayEntry);
        }
        setState(() {
          _expanded = !_expanded;
        });
      },
      height: widget.height,
      columns: widget.columns,
      width: widget.height,
    );
  }

  OverlayEntry createOverlay(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    List<Widget> dots = [];
    for (var i = 0; i < SkinTones.tones.length; i++) {
      dots.add(
        SkinDotButton(
          skin: i,
          onPressed: () {
            _overlayEntry.remove();
            setState(() {
              _skin = i;
              _expanded = false;
            });
            widget.onSkinChanged(_skin);
          },
          columns: widget.columns,
          height: widget.height,
          width: widget.width,
        ),
      );
    }

    var w = size.width * 6;
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx - w + size.width,
              top: offset.dy - size.height,
              width: w,
              height: size.height,
              child: Material(
                elevation: 4.0,
                child: Row(
                  children: dots,
                ),
              ),
            ));
  }
}

class SkinDotButton extends StatelessWidget {
  final int? skin;
  final Function()? onPressed;
  final double width;
  final double height;
  final int columns;

  const SkinDotButton(
      {Key? key,
      this.skin,
      this.onPressed,
      required this.width,
      required this.height,
      required this.columns})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / columns,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0.0),
        ),
        autofocus: true,
        child: SkinDot(
          skin: skin,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
