import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? floatingHintText;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final bool underline;
  final int minLines;
  final int maxLines;
  final bool boxBorder;
  final Color boxBorderColor;
  final double boxBorderWidth;
  final TextStyle? textStyle;
  final bool filled;
  final Color filledColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final double boxBorderRadius;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final Widget? suffixIconButton;
  final bool enabled;
  final Color cursorColor;
  final String Function(String)? validate;
  final String? text;
  final void Function(String)? onDebounceText;
  final void Function()? onTap;
  final bool absorbPointer;
  final bool showSuffixIfHasText;
  final EdgeInsets contentPadding;
  final TextAlign textAlign;

  const AppTextField({
    Key? key,
    // this.controller,
    this.onChanged,
    this.floatingHintText,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
    this.underline = true,
    this.textStyle,
    this.minLines = 1,
    this.maxLines = 1,
    this.boxBorder = false,
    this.boxBorderColor = Colors.black87,
    this.filled = false,
    this.filledColor = Colors.transparent,
    this.boxBorderRadius = 0,
    this.boxBorderWidth = 0,
    this.focusedBorderColor = Colors.black87,
    this.hintStyle,
    this.focusNode,
    this.suffixIconButton,
    this.enabled = true,
    this.cursorColor = Colors.black,
    this.disabledBorderColor = Colors.black38,
    this.validate,
    this.text,
    this.onDebounceText,
    this.absorbPointer = false,
    this.onTap,
    this.showSuffixIfHasText = false,
    this.controller,
    this.contentPadding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTextFieldController appTextFieldStore =
        Get.put(AppTextFieldController(validate), tag: hintText);
    TextTheme textTheme = Theme.of(context).textTheme;
    Debouncer? debouncer;
    if (onDebounceText != null) {
      debouncer = Debouncer(Duration(milliseconds: 250), (s) {
        onDebounceText?.call(s);
      });
    }
    final _controller = controller ?? TextEditingController(text: text);
    if (text != null)
      _controller.selection =
          TextSelection.collapsed(offset: text?.length ?? 0);
    return GetBuilder<AppTextFieldController>(
      tag: hintText,
      builder: (_) {
        return InkWell(
          onTap: absorbPointer ? onTap : null,
          child: AbsorbPointer(
            absorbing: absorbPointer,
            child: TextField(
              key: Key(floatingHintText ?? hintText),
              controller: _controller,
              onChanged: (s) {
                if (validate != null) {
                  appTextFieldStore.checkValidate(s);
                  if (appTextFieldStore.error == null) {
                    onChanged?.call(s);
                  }
                } else {
                  if (onDebounceText != null) {
                    debouncer?.value = s;
                  }
                  onChanged?.call(s);
                }
                if (showSuffixIfHasText) {
                  appTextFieldStore.showSuffix.value =
                      _controller.text.isNotEmpty;
                }
              },
              obscureText: obscureText,
              minLines: minLines,
              maxLines: maxLines,
              enabled: enabled,
              textAlign: textAlign,
              focusNode: focusNode,
              style: textStyle ?? textTheme.subtitle1,
              cursorColor: cursorColor,
              decoration: InputDecoration(
                suffixIcon: showSuffixIfHasText
                    ? appTextFieldStore.showSuffix.value
                        ? suffixIconButton
                        : null
                    : suffixIconButton,
                filled: filled,
                contentPadding: contentPadding,
                fillColor: filledColor,
                labelText: floatingHintText,
                labelStyle: hintStyle ??
                    textTheme.subtitle1?.copyWith(
                      color: Colors.grey[400],
                    ),
                hintText: hintText,
                hintStyle: hintStyle ??
                    textTheme.subtitle1?.copyWith(
                      color: Colors.grey[400],
                    ),
                errorText: appTextFieldStore.error ?? errorText,
                disabledBorder: boxBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(boxBorderRadius),
                        borderSide: BorderSide(
                          color: disabledBorderColor,
                          width: boxBorderWidth,
                          style: BorderStyle.solid,
                        ),
                      )
                    : underline
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(color: disabledBorderColor),
                          )
                        : InputBorder.none,
                focusedBorder: boxBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(boxBorderRadius),
                        borderSide: BorderSide(
                          color: focusedBorderColor,
                          width: boxBorderWidth,
                          style: BorderStyle.solid,
                        ),
                      )
                    : underline
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(color: focusedBorderColor),
                          )
                        : InputBorder.none,
                enabledBorder: boxBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(boxBorderRadius),
                        borderSide: BorderSide(
                          color: boxBorderColor,
                          width: boxBorderWidth,
                          style: BorderStyle.solid,
                        ),
                      )
                    : underline
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(color: boxBorderColor),
                          )
                        : InputBorder.none,
                border: boxBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(boxBorderRadius),
                        borderSide: BorderSide(
                          color: boxBorderColor,
                          width: boxBorderWidth,
                          style: BorderStyle.solid,
                        ),
                      )
                    : underline
                        ? UnderlineInputBorder(
                            borderSide: BorderSide(color: boxBorderColor),
                          )
                        : InputBorder.none,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppTextFieldController extends GetxController {
  final String Function(String)? validate;

  AppTextFieldController(this.validate);

  String? error;
  var showSuffix = false.obs;

  void checkValidate(String s) {
    error = validate?.call(s);
    update();
  }
}

class Debouncer<T> {
  Debouncer(this.duration, this.onValue);

  final Duration duration;
  void Function(T? value) onValue;
  T? _value;
  Timer? _timer;

  T? get value => _value;

  set value(T? val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue.call(_value));
  }
}

class AppRaisedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final String? title;
  final double radius;

  const AppRaisedButton(
      {Key? key,
      this.onPressed,
      this.color,
      this.textColor,
      this.child,
      this.title,
      this.radius = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child ??
          Text(
            title!,
            style: TextStyle(color: textColor),
          ),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class AppLoading extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const AppLoading({Key? key, required this.color, this.strokeWidth = 2.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
      strokeWidth: strokeWidth,
    );
  }
}

class UserPic extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final BoxShape boxShape;
  final Color borderColor;
  final double borderWidth;

  const UserPic(
      {Key? key,
      this.width = 45,
      this.height = 45,
      this.radius = 5,
      this.boxShape = BoxShape.rectangle,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: boxShape,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd0AQjkrS6zdwv-Rp5AnjpI-nM5EbDfhgBOg&usqp=CAU')),
      ),
    );
  }
}
