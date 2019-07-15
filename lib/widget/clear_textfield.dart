import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClearTextField extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final double height;
  final String hintText;
  final String hintTextStyle;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextDirection textDirection;
  final bool autofocus;
  final bool obscureText;
  final bool showCursor;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final IconData prefixIcon;

  final VoidCallback onEditingComplete;

  final ValueChanged<String> onSubmitted;

  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureTapCallback onTapClearIcon;
  final Decoration decoration;

  @override
  _ClearTextFieldState createState() => _ClearTextFieldState();

  const ClearTextField(
      {Key key,
      this.controller,
      this.width = double.infinity,
      this.height = double.infinity,
      this.style,
      this.hintText,
      this.hintTextStyle,
      this.decoration,
      this.focusNode,
      this.keyboardType,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textAlignVertical = TextAlignVertical.center,
      this.textDirection,
      this.showCursor,
      this.autofocus = false,
      this.obscureText = false,
      this.maxLength,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.inputFormatters,
      this.enabled,
      this.onTap,
      this.onTapClearIcon,
      this.prefixIcon})
      : super(key: key);
}

class _ClearTextFieldState extends State<ClearTextField> {
  bool visible = false;

  FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        if (widget.controller != null) {
          setState(() {
            visible =
                focusNode.hasFocus && widget.controller.value.text.isNotEmpty;
          });
        }
      });
    widget.controller?.addListener(() {
      setState(() {
        visible = focusNode.hasFocus && widget.controller.value.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration ??
          BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0)),
      constraints: BoxConstraints(
        maxWidth: widget.width,
        maxHeight: widget.height,
      ),
      child: TextField(
        //cursorColor: Colors.red,
        focusNode: focusNode,
        controller: widget.controller,
        style: widget.style ?? TextStyle(color: Colors.black87, fontSize: 14),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        showCursor: widget.showCursor,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        onTap: widget.onTap,
        maxLines: 1,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(4),
            hintStyle: widget.hintTextStyle ??
                TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon:
                widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
            suffixIcon: Visibility(
              visible: visible,
              child: InkWell(
                onTap: () {
                  widget.controller?.clear();
                  widget.onTapClearIcon?.call();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
            )),
      ),
    );
  }
}
