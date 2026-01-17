import 'package:flutter/material.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class TitleDescription extends StatelessWidget {
  const TitleDescription({
    super.key,
    required this.title,
    required this.prefixIcon,
    required this.hintText,
    required this.maxLines,
    required this.controller,
  });

  final String title;
  final IconData prefixIcon;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Appstyles.lightBlue, width: 2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: Appstyles.oceanGradient,
                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                ),
                child: Icon(prefixIcon, color: Appstyles.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Appstyles.headingTextStyle.copyWith(
                  color: Appstyles.primaryBlue,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.getProportionateHeight(16)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
            boxShadow: Appstyles.softShadow,
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Appstyles.subtitleTextStyle,
              filled: true,
              fillColor: Appstyles.white,
              prefixIcon: Icon(prefixIcon, color: Appstyles.primaryBlue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
