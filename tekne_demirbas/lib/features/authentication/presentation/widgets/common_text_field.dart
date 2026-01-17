import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.obscureText,
    required this.controller,
  });

  final String hintText;
  final TextInputType textInputType;
  final bool? obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
        boxShadow: Appstyles.softShadow,
      ),
      child: TextFormField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: obscureText ?? false,
        style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Appstyles.subtitleTextStyle,
          filled: true,
          fillColor: Appstyles.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
            borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
            borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
            borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
      ),
    );
  }
}
