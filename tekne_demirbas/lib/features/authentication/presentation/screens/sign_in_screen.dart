import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  ConsumerState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Text('Giris yap', style: Appstyles.titleTextStyle)],
        ),
      ),
    );
  }
}
