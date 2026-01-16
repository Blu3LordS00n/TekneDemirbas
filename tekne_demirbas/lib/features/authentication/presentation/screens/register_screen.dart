import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/common_widgets/async_value_ui.dart';
import 'package:tekne_demirbas/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:tekne_demirbas/features/authentication/presentation/widgets/common_text_field.dart';
import 'package:tekne_demirbas/routes/routes.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  ConsumerState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _validateDetails() async {
    String name = _nameController.text.trim();
    String email = _emailEditingController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tüm alanlar doldurulmalı!',
            style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Şifreler eşleşmiyor!',
            style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Şifre en az 6 karakter olmalı!',
            style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
          displayName: name,
        );

    if (result && mounted) {
      // Email verification mesajı göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Email Doğrulama'),
          content: const Text(
            'Kayıt başarılı! Email adresinize doğrulama maili gönderildi. '
            'Lütfen email adresinizi doğrulayın ve giriş yapın.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.goNamed(AppRoutes.signIn.name);
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailEditingController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final state = ref.watch(authControllerProvider);

    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateWidth(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hesap Olustur', style: Appstyles.titleTextStyle),
                  SizedBox(height: SizeConfig.getProportionateHeight(25)),
                  CommonTextField(
                    hintText: 'İsim',
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: _nameController,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(10)),
                  CommonTextField(
                    hintText: 'Mail adresi',
                    textInputType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: _emailEditingController,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(10)),
                  CommonTextField(
                    hintText: 'Şifre',
                    textInputType: TextInputType.text,
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(10)),
                  CommonTextField(
                    hintText: 'Şifre Tekrar',
                    textInputType: TextInputType.text,
                    obscureText: true,
                    controller: _confirmPasswordController,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(25)),
                  InkWell(
                    onTap: _validateDetails,
                    child: Container(
                      alignment: Alignment.center,
                      height: SizeConfig.getProportionateHeight(50),
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 43, 253, 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Kayıt ol',
                              style: Appstyles.normalTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: SizeConfig.getProportionateHeight(20),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hesabın var mı?', style: Appstyles.normalTextStyle),
                      GestureDetector(
                        onTap: () {
                          context.goNamed(AppRoutes.signIn.name);
                        },
                        child: Text(
                          ' Giris yap!',
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
      ),
    );
  }
}
