import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/presentation/widgets/common_text_field.dart';
import 'package:tekne_demirbas/routes/routes.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  ConsumerState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailEditingController = TextEditingController();
  final _passwordController = TextEditingController();

  void dispose() {
    _emailEditingController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.getProportionateWidth(10),
            SizeConfig.getProportionateHeight(50),
            SizeConfig.getProportionateWidth(10),
            0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Giris yap', style: Appstyles.titleTextStyle),
                SizedBox(height: SizeConfig.getProportionateHeight(25)),
                CommonTextField(
                  hintText: 'Mail adresi',
                  textInputType: TextInputType.emailAddress,
                  obscureText: false,
                  controller: _emailEditingController,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                CommonTextField(
                  hintText: 'Sifre',
                  textInputType: TextInputType.text,
                  obscureText: true,
                  controller: _passwordController,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(25)),

                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: SizeConfig.getProportionateHeight(50),
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 43, 253, 2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Giris yap!',
                      style: Appstyles.normalTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: SizeConfig.getProportionateHeight(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.getProportionateHeight(1),
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.getProportionateWidth(5)),
                    Text('OR', style: Appstyles.normalTextStyle),
                    Container(
                      height: SizeConfig.getProportionateWidth(1),
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.getProportionateHeight(40),
                      width: SizeConfig.screenWidth * 0.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabın yok mu?', style: Appstyles.normalTextStyle),
                    GestureDetector(
                      onTap: () {
                        context.goNamed(AppRoutes.register.name);
                      },
                      child: Text(
                        ' Kayıt ol!',
                        style: Appstyles.normalTextStyle.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
