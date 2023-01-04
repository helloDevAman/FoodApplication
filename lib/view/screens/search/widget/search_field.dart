import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Function onSubmit;
  final Function onChanged;
  SearchField({@required this.controller, @required this.hint, @required this.suffixIcon, @required this.iconPressed, this.onSubmit, this.onChanged});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
        filled: true, fillColor: Theme.of(context).cardColor,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: widget.iconPressed,
          icon: Icon(widget.suffixIcon),
        ),
      ),
      onSubmitted: widget.onSubmit,
      onChanged: widget.onChanged,
    );
  }
}
